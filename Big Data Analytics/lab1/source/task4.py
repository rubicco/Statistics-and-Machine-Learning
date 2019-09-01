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


############
#####   4
############


# map as (station_no, temp)
# find maximum read of station
station_temp = lines. \
    map(lambda x: (x[0], float(x[3]))). \
    reduceByKey(max)


# map as ((station, date), precipitation)
# calculate daily precipitation
# map as (station, precipitation)
# find max precipitation of station
station_precipitation = lines_precipitation. \
    map(lambda x: ((x[0], x[1]), float(x[3]))). \
    reduceByKey(lambda x,y: x+y). \
    map(lambda x: (x[0][0], x[1])). \
    reduceByKey(max)


# join them
station_temp_prec = station_temp.join(station_precipitation)

# filter the last data for constraints
station_temp_prec = station_temp_prec. \
    filter(lambda x: x[1][0]>25 and x[1][0]<30 \
    and x[1][1]>100 and x[1][1]<200)

station_temp_prec.saveAsTextFile("res/t4_station_temp_prec")
