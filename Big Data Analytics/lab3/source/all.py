from __future__ import division
from math import radians, cos, sin, asin, sqrt, exp
from datetime import datetime
from pyspark import SparkContext

# function calculates the great circle distance between two points as km
def haversine(lon1, lat1, lon2, lat2):
    lon1, lat1, lon2, lat2 = map(radians, [float(lon1), float(lat1), float(lon2), float(lat2)]) # convert decimal degrees to radians
    dlon = lon2 - lon1 # haversine formula
    dlat = lat2 - lat1
    a = sin(dlat/2)**2 + cos(lat1) * cos(lat2) * sin(dlon/2)**2
    c = 2 * asin(sqrt(a))
    km = 6367 * c
    return km

# function calculates the day difference as day count
def dates_diff(d1, d2):
    date_format = "%Y-%m-%d"
    d1 = datetime.strptime(d1, date_format)
    d2 = datetime.strptime(d2, date_format)
    delta = d1 - d2
    return abs(delta.days)

# function calculates the time difference as hour
def time_diff(t1, t2):
    time_format = "%H:%M:%S"
    t1 = datetime.strptime(t1, time_format)
    t2 = datetime.strptime(t2, time_format)
    delta = t1 - t2
    return abs(delta.total_seconds()/3600)

# function calculates the gaussian kernel
def gaussian_kernel(h,dist):
    var = 2*(h**2)
    dist = dist**2
    kernel = exp(-dist/var)
    return kernel


### CREATE THE SPARK CONTEXT
sc = SparkContext(appName="lab_kernel")

### IMPORT THE DATA
# stations = sc.textFile("../station_data/stations.csv")
# temps = sc.textFile("../station_data/short_temperature_reads.csv")
temps = sc.textFile("/user/x_mimte/data/temperature-readings.csv")
stations = sc.textFile("/user/x_mimte/data//stations.csv")

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
h_distance = 50
h_date = 30
h_time = 2

# filter the rdd to get only the insterested day
rdd = rdd.filter(lambda x: x[1][0]<date)

### Calculate the constant kernels for the day.
# We do this in order to gain a small performance when we calculate kernels for
# different times on the day
dist_data_kernels = rdd.\
    map(lambda x: (\
        gaussian_kernel(h_date, dates_diff(date, x[1][0])) +\
        gaussian_kernel(h_distance, haversine(long, lat, x[2][1], x[2][0])),\
        x[1][1],\
        float(x[1][2])))

# we keep the readings of this data in the cache
dist_data_kernels = dist_data_kernels.cache()

### LOOP FOR CALCULATE KERNELS AND MAKE PREDICTIONS
predictions = []
for time in times:
    # calculate gaussian kernel for time differences and obtain the sum of kernel
    # (1st map) map the final kernel as (final_kernel, temperature)
    # (2nd map) map them as (final_kernel*temperature, final_kernel)
    # reduce the columns by summing them. This results will give us
    # numerator and denominator.
    num, den = dist_data_kernels. \
        map(lambda x: (x[0] + gaussian_kernel(h_time, time_diff(time, x[1])), x[2])). \
        map(lambda x: (x[0]*x[1], x[0])). \
        reduce(lambda x,y: (x[0]+y[0], x[1]+y[1]))
    # divide them and get the prediction for that time,day,location.
    # store them in the array
    predictions.append(num/den)

# parallelize the array in order to create RDD from it and save the results
# to HDFS directory as text file
forecast = sc.parallelize(predictions)
forecast.saveAsTextFile("bda3_res/forecast")
