options(java.parameters = "-Xmx8G")
Sys.setenv(JAVA_HOME = "/Library/Java/JavaVirtualMachines/jdk-21.jdk/Contents/Home")

library(r5r)
library(data.table)
library(dplyr)
library(lubridate)
library(tictoc)

# Define Data Path 
data_path <- "/Users/neezasingh/Downloads/ds-mpo-bikes/MPOCode"
od_path <- file.path(data_path, "bluebike_od_input.csv")

# Setup Routing Engine 
r5r_core <- setup_r5(
  data_path = data_path,
  verbose = TRUE,
  temp_dir = FALSE,
  overwrite = TRUE
)


# STEP 3: Load and Clean OD Data 
full_od_input <- fread(od_path)

# Fix missing times (add 08:00:00 if only date is present)
full_od_input[!grepl(":", departure_datetime), 
              departure_datetime := paste0(substr(departure_datetime, 1, 10), " 08:00:00")]

# Remove " UTC" and parse timestamp
full_od_input[, departure_datetime := gsub(" UTC", "", departure_datetime)]
full_od_input[, parsed_time := ymd_hms(departure_datetime)]

#  STEP 4: Extract Temporal Features 
full_od_input[, started_hour := hour(parsed_time)]
full_od_input[, started_minute := minute(parsed_time)]

round_5_minutes <- function(min) {
  rounded <- round(min / 5) * 5
  ifelse(rounded == 60, 55, rounded)
}
full_od_input[, started_minute := round_5_minutes(started_minute)]

# ---- STEP 5: Spatial Rounding ----
full_od_input[, from_lat_r := round(from_lat, 4)]
full_od_input[, from_lon_r := round(from_lon, 4)]
full_od_input[, to_lat_r   := round(to_lat, 4)]
full_od_input[, to_lon_r   := round(to_lon, 4)]

# STEP 6: Deduplicate by OD-Time Clusters 
deduped_od <- full_od_input %>%
  group_by(from_lat_r, from_lon_r, to_lat_r, to_lon_r,
           season, weekday_type, started_hour, started_minute) %>%
  slice(1) %>%
  ungroup()

setDT(deduped_od)

#  STEP 7: Temporal Bins 
deduped_od[, hour_bin := fifelse(started_hour < 6, "00-05",
                                 fifelse(started_hour < 12, "06-11",
                                         fifelse(started_hour < 18, "12-17", "18-23")))]

#  STEP 8: Stratified Sampling 
samples_per_group <- 100

bike_stratified <- deduped_od[
  , .SD[sample(.N, min(.N, samples_per_group))],
  by = .(season, weekday_type, hour_bin)
]

bike_stratified[, trip_index := .I]  # create index to preserve ID linkage

bike_origins <- bike_stratified[, .(id = paste0("O", trip_index), lat = from_lat, lon = from_lon)]
bike_destinations <- bike_stratified[, .(id = paste0("D", trip_index), lat = to_lat, lon = to_lon)]
departure_time <- as.POSIXct("2024-07-03 08:00:00")  # fixed for now

tictoc::tic("Bike routing")
bike_itineraries <- detailed_itineraries(
  r5r_core,
  origins = bike_origins,
  destinations = bike_destinations,
  mode = "BICYCLE",
  departure_datetime = departure_time,
  max_trip_duration = 90,
  progress = TRUE
)
tictoc::toc()

setDT(bike_itineraries)  # convert to data.table format first
bike_itineraries[, trip_index := as.integer(gsub("[^0-9]", "", from_id))]  # extract numeric part from "O23"
bike_stratified[, trip_index := .I]  # index to match numeric part of ID
bike_itineraries <- merge(
  bike_itineraries,
  bike_stratified[, .(trip_index, original_trip_id = id)],
  by = "trip_index",
  all.x = TRUE
)

cat("Number of routes computed:", nrow(bike_itineraries), "\n")
print(head(bike_itineraries[, .(original_trip_id, from_id, to_id, total_duration, total_distance)]))


tictoc::tic("Walk + Transit Routing")
departure_time <- as.POSIXct("2023-07-11 08:00:00")  

walktransit_itineraries <- detailed_itineraries(
  r5r_core,
  origins = bike_stratified[, .(id = paste0("O", .I), lat = from_lat, lon = from_lon)],
  destinations = bike_stratified[, .(id = paste0("D", .I), lat = to_lat, lon = to_lon)],
  mode = c("WALK", "TRANSIT"),
  departure_datetime = departure_time,
  max_trip_duration = 90,
  progress = TRUE
)

tictoc::toc()
# Step 1: Ensure data.table
setDT(walktransit_itineraries)
setDT(bike_stratified)

# Step 2: Rebuild numeric index for matching
walktransit_itineraries[, trip_index := as.integer(gsub("[^0-9]", "", from_id))]
bike_stratified[, trip_index := .I]

# Step 3: Merge to get original trip ID
walktransit_itineraries <- merge(
  walktransit_itineraries,
  bike_stratified[, .(trip_index, original_trip_id = id)],
  by = "trip_index", 
  all.x = TRUE
)
# Clean up duplicates after merge
walktransit_itineraries[, original_trip_id := original_trip_id.x]
walktransit_itineraries[, c("original_trip_id.x", "original_trip_id.y") := NULL]

walktransit_summary <- walktransit_itineraries[
  distance > 50,  
  .(
    from_id = first(from_id),
    to_id = first(to_id),
    from_lat = first(from_lat),
    from_lon = first(from_lon),
    to_lat = first(to_lat),
    to_lon = first(to_lon),
    departure_time = first(departure_time),
    total_duration = sum(segment_duration),
    total_distance = sum(distance),
    modes_used = paste(unique(mode), collapse = " + "),
    n_segments = .N
  ), by = original_trip_id
]
setdiff(bike_itineraries$original_trip_id, walktransit_summary$original_trip_id)
length(unique(bike_itineraries$original_trip_id))  # Should match
length(unique(walktransit_summary$original_trip_id))

names(walktransit_itineraries)


departure_time <- as.POSIXct("2023-07-11 08:00:00")  

tictoc::tic("Bike + Transit Routing")

biketransit_itineraries <- detailed_itineraries(
  r5r_core,
  origins = bike_stratified[, .(id = paste0("O", .I), lat = from_lat, lon = from_lon)],
  destinations = bike_stratified[, .(id = paste0("D", .I), lat = to_lat, lon = to_lon)],
  mode = c("BICYCLE", "TRANSIT"),
  departure_datetime = departure_time,
  max_trip_duration = 90,
  progress = TRUE
)

tictoc::toc()

setDT(biketransit_itineraries)
setDT(bike_stratified)

biketransit_itineraries[, trip_index := as.integer(gsub("[^0-9]", "", from_id))]
bike_stratified[, trip_index := .I]

biketransit_itineraries <- merge(
  biketransit_itineraries,
  bike_stratified[, .(trip_index, original_trip_id = id)],
  by = "trip_index",
  all.x = TRUE
)

biketransit_summary <- biketransit_itineraries[, .(
  from_id = first(from_id),
  to_id = first(to_id),
  from_lat = first(from_lat),
  from_lon = first(from_lon),
  to_lat = first(to_lat),
  to_lon = first(to_lon),
  departure_time = first(departure_time),
  total_duration = sum(segment_duration),
  total_distance = sum(distance),
  modes_used = paste(unique(mode), collapse = " + "),
  n_segments = .N
), by = original_trip_id]

# ---- Step 5: Preview ----
View(biketransit_itineraries)
cat("otal bike+transit simulated trips:", nrow(biketransit_itineraries), "\n")


biketransit_itineraries <- biketransit_final[, .(
  from_id = first(from_id),
  to_id = first(to_id),
  from_lat = first(from_lat),
  from_lon = first(from_lon),
  to_lat = first(to_lat),
  to_lon = first(to_lon),
  departure_time = first(departure_time),
  total_duration = sum(segment_duration),
  total_distance = sum(distance),
  modes_used = paste(unique(mode), collapse = " + "),
  n_segments = .N
), by = original_trip_id]

# Extract unique trip IDs from each dataset
bike_ids <- unique(bike_itineraries$original_trip_id)
walktransit_ids <- unique(walktransit_summary$original_trip_id)
biketransit_ids <- unique(biketransit_itineraries$original_trip_id)

# Check the number of unique IDs in each
length(bike_ids)
length(walktransit_ids)
length(biketransit_ids)

# Find common IDs across all three modes
common_ids <- Reduce(intersect, list(bike_ids, walktransit_ids, biketransit_ids))
length(common_ids) 


bike_finaldata <- bike_itineraries[original_trip_id %in% common_ids]
walktransit_finaldata <- walktransit_summary[original_trip_id %in% common_ids]
multimodal_finaldata <- biketransit_itineraries[original_trip_id %in% common_ids]


# ---- STEP 1: Prepare summary fields for each mode ----
names(walktransit_finaldata)
names(multimodal_finaldata)
names(bike_finaldata)

walktransit_finaldata[, `:=`(
  walktransit_duration = total_duration,
  walktransit_distance = total_distance,
  n_segments_walktransit = n_segments,
  modes_used_walktransit = modes_used,
  used_transit_in_walktransit = grepl("TRANSIT", modes_used)
), by = original_trip_id]

multimodal_finaldata[, `:=`(
  multimodal_duration = total_duration,
  multimodal_distance = total_distance,
  n_segments_multimodal = n_segments,
  modes_used_multimodal = modes_used,
  used_transit_in_multimodal = grepl("TRANSIT", modes_used)
), by = original_trip_id]

bike_finaldata[, `:=`(
  bike_duration = total_duration,
  bike_distance = total_distance
)]

bike_clean <- bike_finaldata[, .(
  original_trip_id,
  origin_lat = from_lat,
  origin_lon = from_lon,
  dest_lat = to_lat,
  dest_lon = to_lon,
  bike_duration,
  bike_distance
)]

walktransit_clean <- walktransit_finaldata[, .(
  original_trip_id,
  walktransit_duration,
  walktransit_distance,
  n_segments_walktransit,
  modes_used_walktransit,
  used_transit_in_walktransit
)]

multimodal_clean <- multimodal_finaldata[, .(
  original_trip_id,
  multimodal_duration,
  multimodal_distance,
  n_segments_multimodal,
  modes_used_multimodal,
  used_transit_in_multimodal
)]

comparison_df <- Reduce(function(x, y) merge(x, y, by = "original_trip_id", all = TRUE),
                        list(bike_clean, walktransit_clean, multimodal_clean))

print(head(comparison_df))
cat("\Final combined dataset with", nrow(comparison_df), "trips.\n")

# Drop the two columns from the combined dataframe
comparison_df[, c("used_transit_in_walktransit", "used_transit_in_multimodal") := NULL]

# Save final comparison dataset
fwrite(comparison_df, "comparison_df.csv")

# Save individual mode datasets
fwrite(walktransit_finaldata, "walktransit_finaldata.csv")
fwrite(multimodal_finaldata, "multimodal_finaldata.csv")
fwrite(bike_finaldata, "bike_finaldata.csv")
getwd()
setwd("/Users/neezasingh/Downloads/ds-mpo-bikes/MPOCode")

