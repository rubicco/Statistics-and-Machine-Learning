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




############
#####   2.i
############

# map as ((year, month), (station_no, temp, 1))
year_month = lines. \
    map(lambda x: ((x[1][0:4],x[1][5:7]), (x[0], float(x[3]))))

# filter by constraints and put 1 as value
year_month = year_month. \
    filter(lambda x: int(x[0][0])>=1950 and int(x[0][0])<=2014 and x[1][1]>10)

# map as pair rdd (key,1) and count them, sort them
count_reads = year_month. \
    map(lambda x: (x[0], 1)). \
    reduceByKey(lambda x,y: x+y). \
    sortByKey(ascending=False)

count_reads.saveAsTextFile("./res/t2_count_reads_month")


############
#####   2.ii
############
# get only one tuple for a station in one month.
# Remove duplicated reads in one month
year_month_unique = year_month. \
    map(lambda x: (x[0], (x[1][0], 1))). \
    distinct()

# map as pair rdd (key,1) and count them, sort them
station_month_counts = year_month_unique. \
    map(lambda x: (x[0], 1)). \
    reduceByKey(lambda x,y: x+y). \
    sortByKey(ascending=False)

station_month_counts.saveAsTextFile("./res/t2_count_reads_month_distinct")
