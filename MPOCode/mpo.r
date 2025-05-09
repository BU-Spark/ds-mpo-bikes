# Java memory & environment (must go before libraries)
options(java.parameters = "-Xmx4G")
Sys.setenv(JAVA_HOME = "/Library/Java/JavaVirtualMachines/jdk-21.jdk/Contents/Home")

# Load libraries
library(r5r)
library(data.table)
library(dplyr)

# Set  folder path and input file locations
data_path <- "MPOCode"
od_file <- file.path(data_path, "bluebike_od_input.csv")
osm_file <- file.path(data_path, "brmpo-conveyal.osm.pbf")
elevation_file <- file.path(data_path, "mpo_elevation_2023.tif")

# Setup r5 routing engine
r5r_core <- setup_r5(
  data_path = data_path,
  verbose = TRUE,
  temp_dir = FALSE
)


# --- STEP: Simulate Travel Times ---
# Read OD input and restructure to match r5r requirements
raw_input <- fread(od_file)
od_input <- raw_input[, .(id, lat = from_lat, lon = from_lon)]

# Set shared departure time (Tuesday morning)
departure_time <- as.POSIXct("2024-04-16 08:00:00")

# Simulate BIKE-only travel
bike_times <- travel_time_matrix(
  r5r_core,
  origins = od_input,
  destinations = od_input,
  mode = c("BICYCLE"),
  departure_datetime = departure_time,
  max_trip_duration = 60
)

# Simulate TRANSIT-only travel
transit_times <- travel_time_matrix(
  r5r_core,
  origins = od_input,
  destinations = od_input,
  mode = c("WALK", "TRANSIT"),
  departure_datetime = departure_time,
  max_trip_duration = 90
)

# Simulate WALK-only travel
walk_times <- travel_time_matrix(
  r5r_core,
  origins = od_input,
  destinations = od_input,
  mode = c("WALK"),
  departure_datetime = departure_time,
  max_trip_duration = 90
)

# Simulate MULTIMODAL travel
multimodal_times <- travel_time_matrix(
  r5r_core,
  origins = od_input,
  destinations = od_input,
  mode = c("WALK", "BICYCLE", "TRANSIT"),
  departure_datetime = departure_time,
  max_trip_duration = 90
)

# Preview each
head(bike_times)
head(transit_times)
head(walk_times)
head(multimodal_times)
