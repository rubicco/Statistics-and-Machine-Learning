# import pyspark
from pyspark import SparkContext

# create the spark application
sc = SparkContext(appName = "Exercise App")

# import the data
# temperature_file = sc.textFile("../station_data/short_temperature_reads.csv")
temperature_file = sc.textFile("/user/x_mimte/data/temperatures-big.csv")

# transform the data by splitting each line
lines = temperature_file. \
    map(lambda line: line.split(";"))


############
#####   1
############
# transform the data by extracting year and temperature as tuple
year_temperature = lines. \
    map(lambda x: (x[1][0:4], float(x[3])))

# filter data by year
year_temperature = year_temperature. \
    filter(lambda x: int(x[0])>=1950 and int(x[0])<=2014)

# reducer, to get the max temperature by KEY (year)
max_temperatures = year_temperature. \
    reduceByKey(max). \
    sortByKey(ascending=False)
# reducer, to get the min temperature by KEY (year)
min_temperatures = year_temperature. \
    reduceByKey(min). \
    sortByKey(ascending=False)

max_temperatures.saveAsTextFile("./res/t1_max")
min_temperatures.saveAsTextFile("./res/t1_min")


############
#####   1a
############

year_station_temp = lines. \
    map(lambda x: (x[1][0:4], (x[0], float(x[3]))))

year_temperature = year_station_temp. \
    filter(lambda x: int(x[0])>=1950 and int(x[0])<=2014)

max_temperatures = year_temperature. \
    reduceByKey(lambda a,b: a if a>b else b). \
    sortByKey(False)

min_temperatures = year_temperature. \
    reduceByKey(lambda a,b: b if a<b else a). \
    sortByKey(False)




max_temperatures.saveAsTextFile("./res/t1_max_stations")
min_temperatures.saveAsTextFile("./res/t1_min_stations")
