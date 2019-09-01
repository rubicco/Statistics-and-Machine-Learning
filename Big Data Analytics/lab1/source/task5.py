# import pyspark
from pyspark import SparkContext

# create the spark application
sc = SparkContext(appName = "Exercise App")

# import the data
# temperature_file = sc.textFile("../station_data/short_temperature_reads.csv")
temperature_file = sc.textFile("/user/x_mimte/data/temperature-readings.csv")

# transform the data by splitting each line
lines = temperature_file. \
    map(lambda line: line.split(";"))

# import the data
# precipitation_file = sc.textFile("../station_data/short_precipitation-readings.csv")
precipitation_file = sc.textFile("/user/x_mimte/data/precipitation-readings.csv")

# transform the data by splitting each line
lines_precipitation = precipitation_file. \
    map(lambda line: line.split(";"))


# import stations in Ostergotland
# ost_station_file = sc.textFile("../station_data/stations-Ostergotland.csv")
ost_station_file = sc.textFile("/user/x_mimte/data/stations-Ostergotland.csv")


############
#####   5
############

# transform the data by splitting each line
lines_ost = ost_station_file. \
    map(lambda line: line.split(";"))

# get station_ids in Ostergotland as an Array
ost_station_ids = lines_ost. \
    map(lambda x: x[0]).collect()

# map as ((station_no, yyyy, mm), (precipitation, 1))
# filter only ostergotland stations and date constraint
# map as ((yyyy, mm), (precipitation, 1))
# sum all values by reduceByKey
# map it again to find avg of month
# sort
ost_station_prec = lines_precipitation. \
    map(lambda x: ((x[0], x[1][0:4], x[1][5:7]), (float(x[3]), 1))). \
    filter(lambda x: x[0][0] in ost_station_ids and \
        int(x[0][1])>1993 and int(x[0][1])<2016). \
    map(lambda x: ((x[0][1], x[0][2]), x[1])). \
    reduceByKey(lambda x,y: (x[0]+y[0], x[1]+y[1])). \
    map(lambda x: (x[0], x[1][0]/x[1][1])). \
    sortByKey(False)

ost_station_prec.saveAsTextFile("./res/t5_avg_ost_station")
