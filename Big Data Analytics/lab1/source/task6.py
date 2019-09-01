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


# import stations in Ostergotland
# ost_station_file = sc.textFile("../station_data/stations-Ostergotland.csv")
ost_station_file = sc.textFile("/user/x_mimte/data/stations-Ostergotland.csv")


# transform the data by splitting each line
lines_ost = ost_station_file. \
    map(lambda line: line.split(";"))

# get station_ids in Ostergotland as an Array
ost_station_ids = lines_ost. \
    map(lambda x: x[0]).collect()


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
# filter them in order to get only ostergotland stations
# 1 for counting element count while summing
# sum temperature and count how many elements we have
# map it again to find the average
monthly_avg = daily_avg. \
    map(lambda x: ((x[0][0][0:4], x[0][0][5:7], x[0][1]), (x[1],1))). \
    filter(lambda x: x[0][2] in ost_station_ids). \
    reduceByKey(lambda x,y: (x[0] + y[0], x[1] + y[1])). \
    map(lambda x: (x[0], x[1][0]/x[1][1])). \
    sortByKey(False)



############
#####   6
############

# we use the avg temperature monthly that we found before in taks 3
# filter for the year constraint
# map as ((yyyy, mm),(avg_temp, 1))
# reduceByKey and found sum of values by keys
# map it again as ((yyyy, mm), avg) where avg is value[0]/value[1]
# sort them
monthly_avg50_14 = monthly_avg. \
    filter(lambda x: int(x[0][0])>=1950 and int(x[0][0])<=2014). \
    map(lambda x: ((x[0][0], x[0][1]),(x[1], 1))). \
    reduceByKey(lambda x,y: (x[0]+y[0], x[1]+y[1])). \
    map(lambda x: (x[0], x[1][0]/x[1][1])). \
    sortByKey(ascending=False)

# filter again to get only before 1980
# map it as (mm, (avg_temp, 1))
# reduceByKey and found sum of values by keys
# map it again as (mm, avg)
# sort them
long_term_avg = monthly_avg50_14. \
    filter(lambda x: int(x[0][0])<=1980). \
    map(lambda x: (x[0][1], (x[1], 1))). \
    reduceByKey(lambda x,y: (x[0]+y[0], x[1]+y[1])). \
    map(lambda x: (x[0], x[1][0] / x[1][1])). \
    sortByKey(ascending=False)


monthly_avg50_14.saveAsTextFile("res/t6_avg_monthly")
long_term_avg.saveAsTextFile("res/t6_long_term_avg")
