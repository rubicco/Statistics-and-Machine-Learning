from bda3_util import *

sc = SparkContext(appName="lab_kernel")

### IMPORT THE DATA
stations = sc.textFile("../station_data/stations.csv")
temps = sc.textFile("../station_data/short_temperature_reads.csv")
# temps = sc.textFile("/user/x_mimte/data/temperature-readings.csv")
# stations = sc.textFile("/user/x_mimte/data//stations.csv")

### fix/map the data for semicolons
stations = stations. \
    map(lambda line: line.split(";"))
temps = temps. \
    map(lambda line: line.split(";"))

### MAP THE DATA
# map it as
# (station_no, (lat, long))
stations = stations.map(lambda x: (x[0],(x[3], x[4])))

# map it as
# (station_no, (date, time, temp))
temps = temps.map(lambda x: (x[0], (x[1], x[2], float(x[3]))))

### CREATE A BROADCAST TO GET VALUES BY KEY
station_loc = stations.collectAsMap()
bc = sc.broadcast(station_loc)

# map the data (we joined stations with location info)
# (station_no, (date, time, temp), (lat, long))
rdd = temps.map(lambda x: (x[0], x[1], bc.value.get(x[0])))

### SET THE INPUT DAY
lat = 58.4274 # Up to you
long = 14.826 # Up to you
date = "2013-07-04" # Up to you
times = tuple(["{:02d}:00:00".format(i%24) for i in range(4,26,2)])
# lat1, long1 = ('60.1538', '13.8019')

### SETTINGS FOR KERNEL
h_distance = 0.3
h_date = 40
h_time = 3

rdd = rdd.filter(lambda x: x[1][0]<date).cache()

predictions = [forecast_for_time(rdd, lat, long, date, time, h_distance, h_date, h_time) for time in times]

#################

predictions = []

rdd = rdd.filter(lambda x: x[1][0]<date).cache()

for time in times:
    kernels = rdd.\
        map(lambda x: (\
            gaussian_kernel(h_date, dates_diff(date, x[1][0])),\
            gaussian_kernel(h_time, time_diff(time, x[1][1])),\
            gaussian_kernel(h_distance, haversine(long, lat, x[2][1], x[2][0])),\
            float(x[1][2])))
    sum_kernel = kernels.\
        map(lambda x: (\
            x[0] + x[1] + x[2],\
            x[3]))
    pred = sum_kernel.\
        map(lambda x: (time, (x[0]*x[1], x[0]))).\
        reduceByKey(lambda x, y: (x[0]+y[0], x[1]+y[1])).\
        map(lambda x: (time, x[1][0]/x[1][1]))
    predictions.append(pred.collect()[0])


#################

forecast = sc.parallelize(predictions)

forecast.saveAsTextFile("bda3_res/forecast")
