import pandas as pd
df = pd.read_csv('current_bluebikes_stations.csv',header=1)
df.head()

# Check for missing values in each column
print(df.isnull().sum())

# Check the percentage of missing values in each column
print(df.isnull().sum() / len(df) * 100)



# Display data types of each column
print(df.dtypes)

# Display the shape of the DataFrame (rows, columns)
print(df.shape)

# Get info about the DataFrame
print(df.info())

df

no_id_count = df['Station ID (to match to historic system data)'].str.contains('No ID pre-March 2023', na=False).sum()
print(f"Number of 'No ID pre-March 2023' entries: {no_id_count}")

# Check unique values for 'Seasonal Status', 'Municipality', and 'Station ID'
print("Unique values for Seasonal Status:\n", df['Seasonal Status'].unique())
print("\nUnique values for Municipality:\n", df['Municipality'].unique())
print("\nUnique values for Station ID:\n", df['Station ID (to match to historic system data)'].unique())

print(df['Total Docks'].describe())

import numpy as np

df['Station ID (to match to historic system data)'] = df['Station ID (to match to historic system data)'].replace('No ID pre-March 2023', np.nan)

df

print(df.isnull().sum())

df = df[:-6]
df.shape

df
print(df.isnull().sum())



df

print(df.describe())

import matplotlib.pyplot as plt
plt.hist(df['Total Docks'], bins=20)
plt.xlabel('Total Docks')
plt.ylabel('Frequency')
plt.title('Distribution of Total Docks')
plt.show()

import matplotlib.pyplot as plt

plt.hist(df['Total Docks'], bins=20, color='skyblue', edgecolor='black')

plt.xlabel('Total Docks (Number of Docks)', fontsize=12)
plt.ylabel('Frequency (Count)', fontsize=12)
plt.title('Distribution of Total Docks', fontsize=14)

plt.grid(axis='y', linestyle='--', alpha=0.7)



plt.show()

import seaborn as sns

sns.kdeplot(df['Total Docks'], fill=True, color='skyblue')

plt.xlabel('Total Docks (Number of Docks)')
plt.ylabel('Density')
plt.title('KDE Plot of Total Docks')
plt.grid(axis='y', linestyle='--', alpha=0.7)
plt.show()

plt.hist(df['Total Docks'], bins=20, color='#2196F3', edgecolor='black', rwidth=0.9)
plt.xlabel('Total Docks (Number of Docks)')
plt.ylabel('Frequency (Count)')
plt.title('Distribution of Total Docks')
plt.grid(axis='y', linestyle='--', alpha=0.7)
plt.show()

df.groupby('Municipality')['Total Docks'].mean().plot(kind='bar')
plt.xlabel('Municipality')
plt.ylabel('Average Total Docks')
plt.title('Average Total Docks per Municipality')
plt.show()

sns.set_style("whitegrid")


df.groupby('Seasonal Status')['Total Docks'].mean().plot(kind='bar', color='#4C72B0')  # A refined blue shade


plt.xlabel('Seasonal Status', fontsize=12)
plt.ylabel('Average Total Docks', fontsize=12)
plt.title('Average Total Docks per Seasonal Status', fontsize=14, fontweight='bold')


plt.xticks(rotation=45, ha='right')

plt.show()

import matplotlib.pyplot as plt
import seaborn as sns

municipality_counts = df['Municipality'].value_counts()


sns.set_style("whitegrid")
plt.figure(figsize=(12, 6))


colors = sns.color_palette("viridis", len(municipality_counts))
municipality_counts.plot(kind='bar', color=colors)


plt.xlabel('Municipality', fontsize=12)
plt.ylabel('Number of Stations', fontsize=12)
plt.title('Number of Stations per Municipality', fontsize=14, fontweight='bold')


plt.xticks(rotation=45, ha='right')

plt.show()

station_id_counts = df['Station ID (to match to historic system data)'].value_counts()
station_id_counts

filtered_df = df[df['Station ID (to match to historic system data)'] == "214"]

filtered_df

import matplotlib.pyplot as plt
import seaborn as sns

plt.figure(figsize=(10, 6))
sns.boxplot(x='Municipality', y='Total Docks', data=df)
plt.title('Distribution of Total Docks by Municipality')
plt.xlabel('Municipality')
plt.ylabel('Total Docks')
plt.xticks(rotation=45, ha='right')
plt.show()

sns.pairplot(df[['Total Docks', 'Municipality']], diag_kind='kde')
plt.show()

sns.set_style("whitegrid")
plt.figure(figsize=(12, 6))

palette = sns.color_palette("Set2")
sns.boxplot(x='Municipality', y='Total Docks', data=df, palette=palette)


plt.title('Distribution of Total Docks by Municipality', fontsize=14, fontweight='bold')
plt.xlabel('Municipality', fontsize=12)
plt.ylabel('Total Docks', fontsize=12)

plt.xticks(rotation=45, ha='right', fontsize=10)

plt.show()

import matplotlib.pyplot as plt
numerical_cols = ['Total Docks']
sns.pairplot(df[numerical_cols], diag_kind='kde')
plt.show()

import matplotlib.pyplot as plt
import seaborn as sns

sns.set_style("whitegrid")

custom_palette = sns.color_palette("coolwarm")

numerical_cols = ['Total Docks']
sns.pairplot(df[numerical_cols], diag_kind='kde', plot_kws={'color': custom_palette[1]}, diag_kws={'color': custom_palette[0]})

plt.show()