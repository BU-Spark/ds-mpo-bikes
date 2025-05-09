# MPO-Bluebikes

This repository contains code and analysis to explore how Bluebikes trips connect with MBTA transit across Metro Boston. It includes data cleaning, trip classification, travel time comparisons across different transportation modes, and visualizations that highlight where multimodal trips work well together. The project supports the Boston Region MPO in understanding and improving multimodal travel options in the region.

There are currently three core tasks this project addresses:
1. Cleaning and preparing Bluebikes trip data and MBTA GTFS access points for analysis
2. Classifying Bluebikes trips based on proximity to MBTA access points (first mile, last mile, competitive/supplemental, or transit agnostic)
3. Building travel time matrices and multimodal routing patterns using real-world street and transit networks
4. Analyzing route patterns, travel time performance, and identifying efficient modal combinations

## Getting Started

The main workflow begins with `./MPOCode`, which explores and prepares the Bluebikes network data.  
Subsequent steps involve:

- `blue-bike-trips-cleaning-eda.ipynb`: Cleans and structures Bluebikes network data  
- `gtfs-data-cleaning.ipynb`: Parses MBTA GTFS `stops.txt` and filters valid access points within the MPO boundary  
- `trip_classification.ipynb`: Classifies trips into *First Mile*, *Last Mile*, *Competitive/Supplemental*, or *Transit Agnostic* based on MBTA proximity  
- `mpo.r`: Uses the `r5r` routing engine to simulate multimodal travel times (bike, walk, transit, and hybrid)  
- Supporting files include OpenStreetMap `.pbf`, MBTA GTFS `.zip`, and elevation data `.tif` for routing and terrain analysis
  
## Overview

Metro Boston is home to a complex and evolving transportation network where public transit and bikeshare increasingly intersect. In this project, conducted in collaboration with the Boston Region Metropolitan Planning Organization (MPO), we investigate how Bluebikes, Boston’s docked bikeshare system, interacts with the MBTA network to enable more efficient, multimodal travel across the region.

As regional agencies and city planners look to reduce car dependency and improve first- and last-mile access, understanding the spatial and temporal dynamics of Bluebikes usage becomes critical. Our analysis begins with cleaning and processing trip-level data from Bluebikes and geographic access point data from the MBTA's GTFS feed. These datasets are then integrated using spatial joins and geospatial filtering to isolate trips that start or end near transit, enabling us to classify over 3.7 million Bluebikes trips based on their relationship to nearby MBTA stations.

To assess the efficiency of multimodal travel, we simulate real-world travel times using a combination of OpenStreetMap street networks, MBTA schedules, and the r5r routing engine. This allows us to compare models like biking-only trips to walking, transit-only, and multimodal trips. We then develop interactive visualizations to highlight where certain travel modes perform more efficiently across the region.

Through this process, we aim to uncover where Bluebikes most effectively connect to MBTA service, where they serve as substitutes, and how travel behavior differs between urban and suburban areas. The final results of the project include cleaned datasets, the most efficient mode choice for each trip, and interactive visualizations. By comparing travel durations across different modes, we show which options work best in different areas and situations, helping guide better transportation decisions in the Boston region.

## Project Description

The findings from this project will help identify where biking and public transit can better work together to improve travel efficiency and accessibility across the Boston region. By highlighting patterns in how people combine Bluebikes and MBTA services, this work supports future planning efforts to build a more connected, inclusive, and sustainable transportation system that meets the needs of both residents and visitors.

Our primary research question asks where and under what conditions multimodal trips using Bluebikes and MBTA are more efficient, practical, or appealing than using a single mode. We also examine what factors, such as travel time, terrain, and accessibility, influence this effectiveness. Our secondary focus is to understand what local conditions, like transit frequency, bike network quality, and station density, are most closely linked to first or last-mile Bluebikes usage near MBTA stations.

The main challenges in this project involved working with large and complex datasets across different transportation systems. Merging Bluebikes trip data with MBTA GTFS files required careful handling of inconsistent formats and geospatial alignment. Simulating multimodal travel times using the R5R routing engine also presented technical difficulties, especially when incorporating walking, biking, and transit in one route. Due to the high computational cost, we applied sampling strategies to reduce processing time while maintaining representative coverage of trip patterns. Mapping and visualizing these multimodal connections in a clear and meaningful way was another important challenge we addressed throughout the project.

## Project Checklist

1. Clean and preprocess Bluebikes trip data and MBTA GTFS stop data.
2. Classify trips into First Mile, Last Mile, Competitive, and Transit Agnostic categories based on proximity to MBTA access points.
3. Use the R5R routing engine to simulate travel times for walking, biking, transit-only, and multimodal combinations.
4. Apply sampling strategies to reduce computational load while preserving representative travel patterns.
5. Analyze and compare the efficiency of different travel modes across time and geography.
6. Build interactive visualizations to highlight when and where multimodal travel is more efficient.

## Other Folder

`./dataset-documentation`

This folder contains documentation related to the datasets used in the project.  
Currently, it includes `DATASETDOC-sp25.md`, a README file that provides notes, snapshots, and metadata for the datasets used in this version.
