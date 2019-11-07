## Kanye West Database in SQLite

The R file provided will scrape Genius.com and load the data into the accompanying template database, provided you have downloaded DB Browser for SQLite. All that remains to complete the database is to run the SQL INSERT in the appendix. The SQL CREATE TABLE commands used to create the template database are also included in the appendix. The model of the database is below along with a sample of what my final database looked like. The database can be used to answer questions like: "Which producer has Kanye collaborated with most?" (Mike Dean) and "Which artist has been sampled most frequently in Kanye's songs?" (Gil Scott-Heron).
This was my final project for Northwestern University's EECS 317: Data Management and Information Processing. Enjoy!








### Entity Relationship Diagram
![Screen Shot 2019-11-07 at 12 28 56 PM](https://user-images.githubusercontent.com/55408707/68416564-543a1b00-015a-11ea-9555-46912775708d.png)

### Final Database
![Screen Shot 2019-11-07 at 1 07 37 PM](https://user-images.githubusercontent.com/55408707/68419341-a6ca0600-015f-11ea-82c6-8e893cce7735.png)

![Screen Shot 2019-11-07 at 1 07 19 PM](https://user-images.githubusercontent.com/55408707/68419360-b2b5c800-015f-11ea-83be-b842c76f4134.png)


##Appendix

### SQL CREATE TABLE Commands

```
CREATE TABLE Song (
SongID INTEGER PRIMARY KEY,
Song_Name TEXT NOT NULL,
Album_Name TEXT NOT NULL,
Year_Released INTEGER NOT NULL
);

CREATE TABLE Producers_temp (
ProducerID INTEGER PRIMARY KEY,
Producer_Name TEXT NOT NULL
);
CREATE TABLE Producers (
ProducerID INTEGER PRIMARY KEY,
Producer_Name TEXT NOT NULL
);
CREATE TABLE Samples (
SampleID INTEGER PRIMARY KEY,
Sample_Name TEXT NOT NULL,
Sample_Artist TEXT NOT NULL
);
CREATE TABLE Samples_temp (
SampleID INTEGER PRIMARY KEY,
Sample_Name TEXT NOT NULL,
Sample_Artist TEXT NOT NULL
);

CREATE TABLE Features (
FeatureID INTEGER PRIMARY KEY,
Feature_Artist_Name TEXT NOT NULL
);
CREATE TABLE Features_temp (
FeatureID INTEGER PRIMARY KEY,
Feature_Artist_Name TEXT NOT NULL
);
CREATE TABLE Song_Producers (
SongID INTEGER, 
ProducerID INTEGER,
FOREIGN KEY(SongID) REFERENCES Song(SongID),
FOREIGN KEY(ProducerID) REFERENCES Producers(ProducerID),
PRIMARY KEY(SongID, ProducerID)
);

CREATE TABLE Song_Samples (
SongID INTEGER,
SampleID INTEGER,
FOREIGN KEY(SongID) REFERENCES Song(SongID),
FOREIGN KEY(SampleID) REFERENCES Samples(SampleID),
PRIMARY KEY(SongID, SampleID)
);

CREATE TABLE Song_Features (
SongID INTEGER,
FeatureID INTEGER,
FOREIGN KEY(SongID) REFERENCES Song(SongID),
FOREIGN KEY(FeatureID) REFERENCES Features(FeatureID),
PRIMARY KEY(SongID, FeatureID)
);

CREATE TABLE Song_Producers_temp (
Producer_Name TEXT,
Song_Name TEXT,
ID INTEGER PRIMARY KEY
);

CREATE TABLE Song_Features_temp (
Song_Name TEXT, 
Feature_Artist_Name TEXT,
ID INTEGER PRIMARY KEY
);

CREATE TABLE Song_Samples_temp (
Song_Name TEXT, 
Sample_Name TEXT,
Sample_Artist TEXT, 
ID INTEGER PRIMARY KEY
);


```


### SQL INSERT Commands
```
INSERT INTO Producers (Producer_Name)
SELECT DISTINCT Producer_Name FROM Producers_temp;

INSERT INTO Samples (Sample_Artist, Sample_Name)
SELECT DISTINCT Sample_Artist, Sample_Name FROM Samples_temp;

INSERT INTO Features (Feature_Artist_Name)
SELECT DISTINCT Feature_Artist_Name FROM Features_temp;

INSERT INTO Song_Features (SongID, FeatureID)
SELECT DISTINCT SongID, FeatureID FROM Song INNER JOIN Song_Features_temp ON Song.Song_Name = Song_Features_temp.Song_Name INNER JOIN Features ON Song_Features_temp.Feature_Artist_Name = Features.Feature_Artist_Name;

INSERT INTO Song_Producers (SongID, ProducerID)
SELECT DISTINCT SongID, ProducerID FROM Song INNER JOIN Song_Producers_temp ON Song.Song_Name = Song_Producers_temp.Song_Name INNER JOIN Producers on Song_Producers_temp.Producer_Name = Producers.Producer_Name;

INSERT INTO Song_Samples (SongID, SampleID)
SELECT DISTINCT SongID, SampleID FROM Song INNER JOIN Song_Samples_temp on Song.Song_Name = Song_Samples_temp.Song_Name INNER JOIN Samples on Song_Samples_temp.Sample_Name = Samples.Sample_Name;




```


