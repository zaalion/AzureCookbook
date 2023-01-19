CREATE DATABASE electricCarsDB
    COLLATE Latin1_General_100_BIN2_UTF8

-- #1 Specifying where should Synapse load the data files (CSV files) from.
--  in our case, a file system in Azure Data Lake Gen2
CREATE EXTERNAL DATA SOURCE csvfiles
WITH (
    LOCATION = 'https://synapsecookdl01.blob.core.windows.net/rawdata/'
)

-- #2 Specifying the CSV file format, including column delimiters 
CREATE EXTERNAL FILE FORMAT CsvFileFormat
    WITH (
        FORMAT_TYPE = DELIMITEDTEXT,
        FORMAT_OPTIONS(
            FIELD_TERMINATOR = ',',
            STRING_DELIMITER = '"',
            FIRST_ROW  = 2
        )
    );

-- #3 Creating an external table which points to cars.csv file. 
--  cars.csv is the only file in the csvfiles data source
CREATE EXTERNAL TABLE dbo.electricHybridCars
(
    VIN VARCHAR(11),
    Country VARCHAR(20),
    City VARCHAR(20),
    [State] VARCHAR(2),
    [Postal Code] VARCHAR(5),
    [Model Year] VARCHAR(4),
    Make VARCHAR(20)
)
WITH
(
    DATA_SOURCE = csvfiles,
    LOCATION = '*.csv',
    FILE_FORMAT = CsvFileFormat
);

-- Find the number of registered cars per make
SELECT Make, COUNT(*) as Sold FROM dbo.electricHybridCars
GROUP BY Make
ORDER BY Sold DESC