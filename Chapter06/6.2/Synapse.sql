CREATE DATABASE CarsDB
    COLLATE Latin1_General_100_BIN2_UTF8

CREATE EXTERNAL DATA SOURCE files
WITH (
    LOCATION = 'https://synapsecookdl01.blob.core.windows.net/rawdata/'
)

CREATE EXTERNAL FILE FORMAT CsvFormat
    WITH (
        FORMAT_TYPE = DELIMITEDTEXT,
        FORMAT_OPTIONS(
            FIELD_TERMINATOR = ',',
            STRING_DELIMITER = '"',
            FIRST_ROW  = 2
        )
    );

CREATE EXTERNAL TABLE dbo.electricCars
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
    DATA_SOURCE = files,
    LOCATION = '*.csv',
    FILE_FORMAT = CsvFormat
);
GO

-- query the table
SELECT Make, COUNT(*) as Sold FROM dbo.electricCars
GROUP BY Make
ORDER BY Sold DESC


