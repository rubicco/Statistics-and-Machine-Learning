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


# import stations in Ostergotland
# ost_station_file = sc.textFile("../station_data/stations-Ostergotland.csv")
ost_station_file = sc.textFile("/user/x_mimte/data/stations-Ostergotland.csv")

# transform the data by splitting each line
lines_ost = ost_station_file. \
    map(lambda line: line.split(";"))

# map the data for our headers
# We could add all other features too. But we do not have any question
# which asks for all other informations.
ostStationsString = ["station", "station_name"]

ostStationsRow = lines_ost.map(lambda line: (line[0], line[1]))


schemaOstStations = sqlContext.createDataFrame(ostStationsRow, ostStationsString)
schemaOstStations.registerTempTable("oststations")



############
#####   5
############

ostStations = schemaOstStations.select("station")

avg_monthly = schemaOstStations.\
    join(schemaPrecipitation, "station").\
    where("year>1993 and year<2016").\
    groupby("year", "month", "station").\
    agg(F.sum("value").alias("total_prec")).\
    groupBy("year", "month").\
    agg(F.avg("total_prec").alias("avg_prec")).\
    orderBy("year", "month", ascending=False)

avg_monthly.rdd.saveAsTextFile("./bda2_res/t5_avg_ost_station")
