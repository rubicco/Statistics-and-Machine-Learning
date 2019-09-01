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
#####   3
############

avg_monthly = schemaTempReadings.\
    where("year>=1960 and year<=2014").\
    groupby("date", "year", "month", "station").\
    agg(((F.max("value") + F.min("value"))/2).alias("avg_daily")).\
    groupby("year", "month", "station").\
    agg(F.avg("avg_daily").alias("avg_monthly")).\
    orderBy("year", "month", ascending=False)
    # orderBy("avg_daily", ascending=False)

avg_monthly.rdd.saveAsTextFile("./bda2_res/t3_avg_month")
