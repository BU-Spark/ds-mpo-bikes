# MPO-Bluebikes

This repository contains a software pipeline to analyze the relationship between Bluebikes trips and MBTA transit accessibility in Metro Boston. The project is part of a collaborative effort with the Boston Region Metropolitan Planning Organization (MPO) to support data-driven planning for multimodal transportation.

There are currently three core tasks this project addresses:
1. Cleaning and preparing Bluebikes trip data and MBTA GTFS access points for analysis
2. Classifying Bluebikes trips based on proximity to MBTA access points (first mile, last mile, competitive/supplemental, or transit agnostic)
3. Building travel time matrices and multimodal routing patterns using real-world street and transit networks

## Getting Started

The main workflow begins with `Clean_bluebike_network_andEDA.ipynb`, which explores and prepares the Bluebikes network data.  
Subsequent steps involve:

- `blue-bike-trips-cleaning-eda.ipynb`: Cleans and structures Bluebikes network data  
- `gtfs-data-cleaning.ipynb`: Parses MBTA GTFS `stops.txt` and filters valid access points within the MPO boundary  
- `trip_classification.ipynb`: Classifies trips into *First Mile*, *Last Mile*, *Competitive/Supplemental*, or *Transit Agnostic* based on MBTA proximity  
- `mpo.r`: Uses the `r5r` routing engine to simulate multimodal travel times (bike, walk, transit, and hybrid)  
- Supporting files include OpenStreetMap `.pbf`, MBTA GTFS `.zip`, and elevation data `.tif` for routing and terrain analysis  

Each stage outputs intermediate files that are ready for travel time matrix generation, trip-type analysis, and geospatial visualization.

## Overview

Metro Boston is home to a complex and evolving transportation network where public transit and bikeshare increasingly intersect. In this project, conducted in collaboration with the Boston Region Metropolitan Planning Organization (MPO), we investigate how Bluebikes, Boston’s docked bikeshare system, interacts with the MBTA network to enable more efficient, multimodal travel across the region.

As regional agencies and city planners look to reduce car dependency and improve first- and last-mile access, understanding the spatial and temporal dynamics of Bluebikes usage becomes critical. Our analysis begins with cleaning and processing trip-level data from Bluebikes and geographic access point data from the MBTA's GTFS feed. These datasets are then integrated using spatial joins and geospatial filtering to isolate trips that start or end near transit, enabling us to classify over 3.7 million Bluebikes trips based on their relationship to nearby MBTA stations.

To assess the efficiency of multimodal travel, we simulate real-world travel times using a combination of OpenStreetMap street networks, MBTA schedules, and the r5r routing engine. This allows us to compare biking-only trips to walking, transit-only, and hybrid combinations that involve both biking and public transit. We also incorporate elevation and traffic stress data to analyze how terrain may influence user choice and route competitiveness.

Through this process, we aim to uncover where Bluebikes most effectively connect to MBTA service, where they serve as substitutes, and how travel behavior shifts in response to service disruptions or infrastructure gaps. The final outputs of the project—including cleaned datasets, classification schemas, multimodal travel time matrices, and interactive visualizations—will inform the MPO’s efforts to enhance multimodal accessibility, optimize transit planning, and support equitable, climate-conscious transportation strategies across the Boston region.