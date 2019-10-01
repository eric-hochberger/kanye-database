This Readme will allow a user to recreate the Kanye West Relational Database with the accompanying KanyeScrapingClean.R. All queries must be run in a SQLite database named my-db.sqlite. CREATE TABLE Song (
SongID INTEGER PRIMARY KEY,
Song_Name TEXT NOT NULL,
Album_Name TEXT NOT NULL,
Year_Released INTEGER NOT NULL
)

CREATE TABLE Producers (
ProducerID INTEGER PRIMARY KEY,
Producer_Name TEXT NOT NULL
)

CREATE TABLE Samples (
SampleID INTEGER PRIMARY KEY,
Sample_Name TEXT NOT NULL,
Sample_Artist TEXT NOT NULL
)

CREATE TABLE Features (
FeatureID INTEGER PRIMARY KEY,
Feature_Artist_Name TEXT NOT NULL
)

CREATE TABLE Song_Producers (
SongID INTEGER, 
ProducerID INTEGER,
FOREIGN KEY(SongID) REFERENCES Song(SongID),
FOREIGN KEY(ProducerID) REFERENCES Producers(ProducerID),
PRIMARY KEY(SongID, ProducerID)
)

CREATE TABLE Song_Samples (
SongID INTEGER,
SampleID INTEGER,
FOREIGN KEY(SongID) REFERENCES Song(SongID),
FOREIGN KEY(SampleID) REFERENCES Samples(SampleID),
PRIMARY KEY(SongID, SampleID)
)

CREATE TABLE Song_Features (
SongID INTEGER,
FeatureID INTEGER,
FOREIGN KEY(SongID) REFERENCES Song(SongID),
FOREIGN KEY(FeatureID) REFERENCES Features(FeatureID),
PRIMARY KEY(SongID, FeatureID)
)
Temporary TablesCREATE TABLE Song_Producers_temp (Producer_Name TEXT,Song_Name TEXT,ID INTEGER PRIMARY KEY)CREATE TABLE Song_Features_temp (Song_Name TEXT, Feature_Artist_Name TEXT,ID INTEGER PRIMARY KEY)CREATE TABLE Song_Samples_temp (Song_Name TEXT, Sample_Name TEXT,Sample_Artist TEXT, ID INTEGER PRIMARY KEY)After the tables are created within a SQLite database named my-db.sqlite, the R file can now be executed. Once the data is scraped and loaded into SQLite for all tables, each table with a “_temp” suffix is to be made temporary within DB Browser for SQLite by selecting each of these tables, clicking “Modify Table” and clicking the “Advanced” dropdown menu and changing “Database schema” to “temp.” The following queries should then be executed:Insert FunctionsINSERT INTO Song_Features (SongID, FeatureID)SELECT DISTINCT SongID, FeatureID FROM Song INNER JOIN Song_Features_temp ON Song.Song_Name = Song_Features_temp.Song_Name INNER JOIN Features ON Song_Features_temp.Feature_Artist_Name = Features.Feature_Artist_Name;INSERT INTO Song_Producers (SongID, ProducerID)SELECT DISTINCT SongID, ProducerID FROM Song INNER JOIN Song_Producers_temp ON Song.Song_Name = Song_Producers_temp.Song_Name INNER JOIN Producers on Song_Producers_temp.Producer_Name = Producers.Producer_Name;INSERT INTO Song_Samples (SongID, SampleID)SELECT DISTINCT SongID, SampleID FROM Song INNER JOIN Song_Samples_temp on Song.Song_Name = Song_Samples_temp.Song_Name INNER JOIN Samples on Song_Samples_temp.Sample_Name = Samples.Sample_Name;