# import pyspark
from pyspark import SparkContext
import time

start = time.time()
# create the spark application
sc = SparkContext(appName = "Exercise App")

# import the data
# temperature_file = sc.textFile("../station_data/short_temperature_reads.csv")
temperature_file = sc.textFile("/user/x_mimte/data/temperatures-big.csv")

# transform the data by splitting each line
lines = temperature_file. \
    map(lambda line: line.split(";"))


year_temperature = lines. \
    map(lambda x: (x[1][0:4], float(x[3]))). \
    filter(lambda x: int(x[0])>=1950 and int(x[0])<=2014). \
    reduceByKey(max). \
    sortByKey(ascending=False)


end = time.time()

print("RUNTIME = {}".format(end - start))


max_temperatures.saveAsTextFile("./res/t1_max")
