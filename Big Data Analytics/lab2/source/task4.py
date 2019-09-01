# import libraries
from pyspark import SparkContext
from pyspark.sql import SQLContext, Row
from pyspark.sql import functions as F

# create Contexts
sc = SparkContext()
sqlContext = SQLContext(sc)

# Load a text file and convert each line to a tuple.
# temperature_file = sc.textFile("../station_data/short_temperature_reads.csv")
# temperature_file = sc.textFile("/user/x_mimte/data/temperatures-big.csv")
temperature_file = sc.textFile("/user/x_mimte/data/temperature-readings.csv")

# transform the data by splitting each line
lines = temperature_file. \
    map(lambda line: line.split(";"))

# define headers of the dataframe
tempReadingsString = ["station", "date", "year", "month", "time", "value", "quality"]

# map the data for our headers
# ['103100', '1996-07-06', '15:00:00', '14.8', 'G']
tempReadingsRow = lines.map(lambda line: (line[0], line[1], int(line[1][0:4]), \
                            int(line[1][5:7]), line[2], \
                            float(line[3]), line[4]))


# Apply the schema to the RDD.
schemaTempReadings = sqlContext.createDataFrame(tempReadingsRow, tempReadingsString)
schemaTempReadings.registerTempTable("tempReadingsTable")

# import the data
# precipitation_file = sc.textFile("../station_data/short_precipitation-readings.csv")
precipitation_file = sc.textFile("/user/x_mimte/data/precipitation-readings.csv")

# transform the data by splitting each line
lines_precipitation = precipitation_file. \
    map(lambda line: line.split(";"))

# define headers of the dataframe
precipitationString= ["station", "date", "year", "month", "time", "value", "quality"]

precipitationRow = lines_precipitation.map(lambda line: (line[0], line[1], int(line[1][0:4]), \
                            int(line[1][5:7]), line[2], \
                            float(line[3]), line[4]))

schemaPrecipitation = sqlContext.createDataFrame(precipitationRow, precipitationString)
schemaPrecipitation.registerTempTable("precipitationtable")


############
#####   4
############


max_temp = schemaTempReadings.\
    groupby("station").\
    agg(F.max("value").alias("max_temp")).\
    where("max_temp>=25 and max_temp<=30")



max_daily_prec = schemaPrecipitation.\
    groupby("date", "station").\
    agg(F.sum("value").alias("daily_prec")).\
    groupby("station").\
    agg(F.max("daily_prec").alias("max_prec")).\
    where("max_prec>100 and max_prec<200")

max_values = max_temp.\
    join(max_daily_prec, "station")

max_values.rdd.saveAsTextFile("./bda2_res/t4_station_temp_prec")
