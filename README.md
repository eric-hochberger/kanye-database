## Kanye West Database in SQLite

The R file provided will scrape Genius.com and load the data into the accompanying template database, provided you have downloaded DB Browser for SQLite. All that remains to complete the database is to run the SQL INSERT commands at the bottom of this doc. The model of the database is below along with a sample (ha-ha) of what my final database looked like. The database can be used to answer questions like: "Which producer has Kanye collaborated with most?" (Mike Dean) and "Which artist has been sampled most frequently in Kanye's songs?" (Gil Scott-Heron).
This was my final project for Northwestern University's EECS 317: Data Management and Information Processing. Enjoy!








### Entity Relationship Diagram
![Screen Shot 2019-11-07 at 12 28 56 PM](https://user-images.githubusercontent.com/55408707/68416564-543a1b00-015a-11ea-9555-46912775708d.png)


### SQL INSERT Commands
```
INSERT INTO Song_Features (SongID, FeatureID)
SELECT DISTINCT SongID, FeatureID FROM Song INNER JOIN Song_Features_temp ON Song.Song_Name = Song_Features_temp.Song_Name INNER JOIN Features ON Song_Features_temp.Feature_Artist_Name = Features.Feature_Artist_Name;

INSERT INTO Song_Producers (SongID, ProducerID)
SELECT DISTINCT SongID, ProducerID FROM Song INNER JOIN Song_Producers_temp ON Song.Song_Name = Song_Producers_temp.Song_Name INNER JOIN Producers on Song_Producers_temp.Producer_Name = Producers.Producer_Name;

INSERT INTO Song_Samples (SongID, SampleID)
SELECT DISTINCT SongID, SampleID FROM Song INNER JOIN Song_Samples_temp on Song.Song_Name = Song_Samples_temp.Song_Name INNER JOIN Samples on Song_Samples_temp.Sample_Name = Samples.Sample_Name;




```


