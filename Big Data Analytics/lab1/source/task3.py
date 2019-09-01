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
#####   3
############

# map as (date, station_no), (temperature)
# to calculate average temp of each day
yr_mn_st = lines. \
    map(lambda x: ((x[1], x[0]), (float(x[3]))))

# calculate avg temp for each day by using defined formula
# avg of min of day and max of day
# we grouped it by key in order to apply function to days for each station seperately
daily_avg = yr_mn_st.groupByKey().mapValues(lambda x: (max(x)+min(x))/2)

# calculate average of month for each station
# map as (year, month, station_no), (daily_avg, 1)
# 1 for counting element count while summing
# sum temperature and count how many elements we have
# map it again to find the average
monthly_avg = daily_avg. \
    map(lambda x: ((x[0][0][0:4], x[0][0][5:7], x[0][1]), (x[1],1))). \
    reduceByKey(lambda x,y: (x[0] + y[0], x[1] + y[1])). \
    map(lambda x: (x[0], x[1][0]/x[1][1])). \
    sortByKey(False)

monthly_avg.filter(lambda x: int(x[0][0])>1960 and int(x[0][0])<2014). \
    saveAsTextFile("./res/t3_avg_month")
