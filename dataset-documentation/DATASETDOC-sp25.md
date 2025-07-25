***Project Information*** 

* What is the project name?
  * MPO: Understanding Blue Bikes And MBTA Use  
* What is the link to your project’s GitHub repository?
  * https://github.com/BU-Spark/ds-mpo-bikes/tree/main 
* What is the link to your project’s Google Drive folder? 
  * https://drive.google.com/drive/folders/1XoIRu1qK6h9qQ_hGPmZ32uvHzm9SKJb1?usp=sharing 
* In your own words, what is this project about? What is the goal of this project?
  *  This project investigates how Bluebikes and the MBTA transit system interact, aiming to understand when and where combining the two modes is more effective than using just one. By analyzing trip data, the goal is to identify patterns of first/last-mile connections and mode substitution to support a more integrated and efficient transportation network in the Boston region.
* Who is the client for the project?
  * Boston Region Metropolitan Planning Organization (MPO)
* Who are the client contacts for the project?
  * Tanner Bonner tbonner@ctps.org, Rosemary McMarron rmccarron@ctps.org 
* What class was this project part of?
  * DS539

***Dataset Information***

* What data sets did you use in your project? Please provide a link to the data sets, this could be a link to a folder in your GitHub Repo, Spark\! owned Google Drive Folder for this project, or a path on the SCC, etc.
  * https://drive.google.com/drive/folders/14gm79BXKytE_HX5z8EM5RL6AFMYhvOq1?usp=drive_link
* Please provide a link to any data dictionaries for the datasets in this project. If one does not exist, please create a data dictionary for the datasets used in this project. **(Example of data dictionary)**
  * MBTA GTFS data dictionary: https://github.com/mbta/gtfs-documentation/blob/master/reference/gtfs-archive.md
* What keywords or tags would you attach to the data set?  
  * Domains of Application: Topic Modeling, Summarization, Anomaly Detection, Geospatial Analysis.   
  * Sustainability, Civic Tech, Transportation. 

*The following questions pertain to the datasets you used in your project.*   

*Composition*

* What do the instances that comprise the dataset represent (e.g., documents, photos, people, countries)? Are there multiple types of instances (e.g., movies, users, and ratings; people and interactions between them; nodes and edges)? What is the format of the instances (e.g., image data, text data, tabular data, audio data, video data, time series, graph data, geospatial data, multimodal (please specify), etc.)? Please provide a description.
  * The datasets represent geospatial and behavioral transportation records. MBTA access points describe transit stops and entrances; Bluebikes stations describe physical dock locations; and Bluebikes trip records represent individual bike trips taken by users. There are three types: MBTA access points (stops/stations), Bluebikes station infrastructure, and Bluebikes trip records. The data is in tabular and geospatial formats (CSV and GeoJSON), with time-series attributes in the trip data and geolocation attributes in all three datasets.
* How many instances are there in total (of each type, if appropriate)?
  * MBTA Access Points: 7,751
  * Bluebikes Stations: 485
  * Bluebikes Trips: 3,701,483
* Does the dataset contain all possible instances or is it a sample (not necessarily random) of instances from a larger set? If the dataset is a sample, then what is the larger set? Is the sample representative of the larger set? If so, please describe how this representativeness was validated/verified. If it is not representative of the larger set, please describe why not (e.g., to cover a more diverse range of instances, because instances were withheld or unavailable).
  * The Bluebikes station and MBTA stop data represent full infrastructure within the Boston MPO boundary. The Bluebikes trip data is a filtered sample of valid user trips, excluding system-generated and anomalous trips, but still representative of typical rider behavior.
* What data does each instance consist of? “Raw” data (e.g., unprocessed text or images) or features? In either case, please provide a description.
  * Each instance includes “raw” data such as timestamps, coordinates, and station names, along with  features like trip duration, weekday indicators, and spatial identifiers.
* Is there any information missing from individual instances? If so, please provide a description, explaining why this information is missing (e.g., because it was unavailable). This does not include intentionally removed information, but might include redacted text.
  * Yes, some optional fields (e.g., platform_code, stop_desc, or Seasonal Status) contain missing values, which is expected for transit datasets. These do not affect the integrity of analysis-critical fields.
* Are there recommended data splits (e.g., training, development/validation, testing)? If so, please provide a description of these splits, explaining the rationale behind them.
  * No specific data splits are recommended.
* Are there any errors, sources of noise, or redundancies in the dataset? If so, please provide a description.
  * The original datasets included noise such as duplicate trips, implausible durations, and loop trips, all of them were removed during the cleaning.
* Is the dataset self-contained, or does it link to or otherwise rely on external resources (e.g., websites, tweets, other datasets)? If it links to or relies on external resources.
  * The dataset is self-contained.
* Are there guarantees that they will exist, and remain constant, over time?
  * It is not guaranteed, the GTFS and Bluebikes system files may be updated or removed periodically.
* Are there official archival versions of the complete dataset (i.e., including the external resources as they existed at the time the dataset was created)?
  * MBTA GTFS Archive Github: https://github.com/mbta/gtfs-documentation/blob/master/reference/gtfs-archive.md
* Are there any restrictions (e.g., licenses, fees) associated with any of the external resources that might apply to a dataset consumer? Please provide descriptions of all external resources and any restrictions associated with them, as well as links or other access points as appropriate.
  * Though our dataset were provided by the clients, these datasets are based on publicly available sources (MBTA GTFS and Bluebikes Open Data).
* Does the dataset contain data that might be considered confidential (e.g., data that is protected by legal privilege or by doctor-patient confidentiality, data that includes the content of individuals’ non-public communications)? If so, please provide a description.   
* Does the dataset contain data that, if viewed directly, might be offensive, insulting, threatening, or might otherwise cause anxiety? If so, please describe why.
  * The datasets are not confidential.
* Is it possible to identify individuals (i.e., one or more natural persons), either directly or indirectly (i.e., in combination with other data) from the dataset? If so, please describe how.
  * No. All content is infrastructure- and trip-based; there is no user-generated or textual data.
* Dataset Snapshot, if there are multiple datasets please include multiple tables for each dataset. 

OD Compatible Dataset
| Size of dataset | ~237.6 MB (after filtering and formatting) |
| :---- | :---- |
| Number of instances | 3,701,483 rows (each representing one trip) |
| Number of fields  | 8 fields |
| Labeled classes | N/A |
| Number of labels  | N/A |

Travel Time Dataset
| Size of dataset | 0.52 MB |
| :---- | :---- |
| Number of instances | 2,400 rows (each representing a unique OD pair simulation) |
| Number of fields  | 14 columns |
| Labeled classes | 3 routing types: bike, walk + transit, multimodal (walk + bike + transit) |
| Number of labels  | 33 for walk+transit, 15 for multimodal |

Cleaned Bluebike Trips Data
| Size of dataset |  ~1.25 GB (estimated for 3.7 million rows x 23 columns) |
| :---- | :---- |
| Number of instances | 3,701,483 rows |
| Number of fields  | 23 columns |
| Labeled classes | first_mile, last_mile, comp_supp, transit_agnostic |
| Number of labels  | 4 |

Cleaned Bluebike Network Dataset
| Size of dataset | ~38 KB (small station reference file in CSV format) |
| :---- | :---- |
| Number of instances | 485 rows (after removing placeholder or imcomplete entries) |
| Number of fields  | 8 columns |
| Labeled classes | N/A |
| Number of labels  | N/A |

MBTA Access Point Summary Dataset
| Size of dataset | ~95 KB (CSV summary of change types) |
| :---- | :---- |
| Number of instances | 7,848 total rows (retained + added + removed) |
| Number of fields  | 8~10 columns (depending on export schema, like stop_id, geometry, change_type) |
| Labeled classes | retained, added, removed |
| Number of labels  | 3 |

Cleaned MBTA Access Point (GTFS stop.txt, July 2024)
| Size of dataset |  ~250 KB (GeoJSON + CSV after filtering and deduplication) |
| :---- | :---- |
| Number of instances | 7,751 rows (final access points within MPO boundary) |
| Number of fields  | 20+ columns (from GTFS+ derived fields like geometry, loc_id) |
| Labeled classes | N/A |
| Number of labels  | N/A |

 
*Collection Process*

* What mechanisms or procedures were used to collect the data (e.g., API, artificially generated, crowdsourced \- paid, crowdsourced \- volunteer, scraped or crawled, survey, forms, or polls, taken from other existing datasets, provided by the client, etc)? How were these mechanisms or procedures validated?
  * The dataset was given to us from the client directly. 
* If the dataset is a sample from a larger set, what was the sampling strategy (e.g., deterministic, probabilistic with specific sampling probabilities)?
  * The datasets are samples from larger sets. The client give it to us on purpose, since the dataset represents the peak of Bluebikes and MBTA uses in a year. Furthermore, we have sampled the dataset by ourselves for travel time calculation for different trip modes in r5r.
* Over what timeframe was the data collected? Does this timeframe match the creation timeframe of the data associated with the instances (e.g., recent crawl of old news articles)? If not, please describe the timeframe in which the data associated with the instances was created.
  * The Bluebikes trip dataset contained every trip record from April to November in 2024. The MBTA GTFS datasets contained the MBTA schedule from April and July in 2024.

*Preprocessing/cleaning/labeling* 

* Was any preprocessing/cleaning/labeling of the data done (e.g., discretization or bucketing, tokenization, part-of-speech tagging, SIFT feature extraction, removal of instances, processing of missing values)? If so, please provide a description. If not, you may skip the remaining questions in this section.
  * The dataset are processed and cleaned. The MBTA data was filtered by location type, spatially joined to the Boston MPO boundary, and deduplicated using spatial IDs. Bluebikes station data was cleaned by handling missing values, standardizing Station IDs, and removing placeholder entries. Bluebikes trip data was cleaned by parsing timestamps, filtering implausible and loop trips, standardizing station names, and engineering temporal features.
  * Additionally, the raw Bluebikes trips data were filtered by several criteria. Trips with missing or incomplete station information were excluded. Only trips that started and ended at stations with at least 100 recorded trips between April and November were retained. Trips were required to have a duration of at least two minutes and no more than two hours. Trips that started and ended at the same station were removed to focus on meaningful travel behavior.
* Were any transformations applied to the data (e.g., cleaning mismatched values, cleaning missing values, converting data types, data aggregation, dimensionality reduction, joining input sources, redaction or anonymization, etc.)? If so, please provide a description.
  * Transformations included data type conversions, spatial filtering, geospatial joins, text standardization, removal of invalid records, and feature extraction. Derived columns such as trip duration, hour, and weekday were added to support analysis.
* Was the “raw” data saved in addition to the preprocessed/cleaned/labeled data (e.g., to support unanticipated future uses)? If so, please provide a link or other access point to the “raw” data, this could be a link to a folder in your GitHub Repo, Spark\! owned Google Drive Folder for this project, or a path on the SCC, etc.
  * Yes, the raw data (MBTA stops.txt, Bluebikes station CSV, and trip records) was preserved for reproducibility and future use. The raw dataset: https://drive.google.com/drive/folders/14gm79BXKytE_HX5z8EM5RL6AFMYhvOq1?usp=drive_link
* Is the code that was used to preprocess/clean the data available? If so, please provide a link to it (e.g., EDA notebook/EDA script in the GitHub repository).
  * Data cleaning documentation: https://docs.google.com/document/d/1FzdtsCBZPhOqdaO4NSjKzigySJM6dWPkbg1xh9vocUM/edit?usp=sharing

*Uses* 

* What tasks has the dataset been used for so far? Please provide a description.
  * Bluebike Trip and Bluebike network data are used to analyze the the travel pattern via Bluebikes, the MBTA GTFS datasets are used to analyze the travel pattern by all the public transits.
* What (other) tasks could the dataset be used for?
  * With the combination of all the trip datasets, open street map and elevation files, we use r5r as the metric to calculate the travel time for different travel modes.
* Is there anything about the composition of the dataset or the way it was collected and preprocessed/cleaned/labeled that might impact future uses?
  * Machine learning can be used in further study on the final travel time analysis dataset.

*Distribution*

* Based on discussions with the client, what access type should this dataset be given (eg., Internal (Restricted), External Open Access, Other)?
  * The dataset is from the client, so only those working on the dataset should have access to it.

*Maintenance* 

* If others want to extend/augment/build on/contribute to the dataset, is there a mechanism for them to do so? If so, please provide a description.
  * Reading the dataset documentation is the best way for others to continue build on the project. The documentation includes all the description of every dataset and explaination of our data cleaning process.

