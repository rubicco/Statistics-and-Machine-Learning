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
tempReadingsString= ["station", "date", "year", "month", "time", "value", "quality"]

# map the data for our headers
# ['103100', '1996-07-06', '15:00:00', '14.8', 'G']
tempReadingsRow = lines.map(lambda line: (line[0], line[1], int(line[1][0:4]), \
                            int(line[1][5:7]), line[2], \
                            float(line[3]), line[4]))

# Apply the schema to the RDD.
schemaTempReadings = sqlContext.createDataFrame(tempReadingsRow, tempReadingsString)
schemaTempReadings.registerTempTable("tempReadingsTable")


############
#####   1
############
df_year_station = schemaTempReadings. \
    where("year >= 1950 and year <= 2014"). \
    groupBy("year")

df_year_station_max = df_year_station. \
    agg(F.max("value").alias("max_temp")). \
    orderBy("max_temp", ascending=False)

df_year_station_min = df_year_station. \
    agg(F.min("value").alias("min_temp")). \
    orderBy("min_temp", ascending=False)


df_year_station_max.rdd.saveAsTextFile("./bda2_res/t1_max_stations")
df_year_station_min.rdd.saveAsTextFile("./bda2_res/t1_min_stations")


############
#####   1
############
df_year_station = schemaTempReadings. \
    where("year >= 1950 and year <= 2014"). \
    groupBy("year", "station")

df_year_station_max = df_year_station. \
    agg(F.max("value").alias("max_temp")). \
    orderBy("max_temp", ascending=False)

df_year_station_min = df_year_station. \
    agg(F.min("value").alias("min_temp")). \
    orderBy("min_temp", ascending=False)

df_year_station_max.rdd.saveAsTextFile("./bda2_res/t1_max_with_stations")
df_year_station_min.rdd.saveAsTextFile("./bda2_res/t1_min_with_stations")
