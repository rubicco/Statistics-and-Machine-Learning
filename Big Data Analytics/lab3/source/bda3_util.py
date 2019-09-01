from __future__ import division
from math import radians, cos, sin, asin, sqrt, exp
from datetime import datetime
from pyspark import SparkContext

"""
Calculate the great circle distance between two points
on the earth (specified in decimal degrees)
"""
def haversine(lon1, lat1, lon2, lat2):
    lon1, lat1, lon2, lat2 = map(radians, [float(lon1), float(lat1), float(lon2), float(lat2)]) # convert decimal degrees to radians
    dlon = lon2 - lon1 # haversine formula
    dlat = lat2 - lat1
    a = sin(dlat/2)**2 + cos(lat1) * cos(lat2) * sin(dlon/2)**2
    c = 2 * asin(sqrt(a))
    km = 6367 * c
    return km/1000

def dates_diff(d1, d2):
    date_format = "%Y-%m-%d"
    d1 = datetime.strptime(d1, date_format)
    d2 = datetime.strptime(d2, date_format)
    delta = d1 - d2
    return abs(delta.days)

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

def sum_all(*args):
    res = 0
    for el in args:
        res += el
    return(res)

def multiply_all(*args):
    res = 1
    for el in args:
        res *= el
    return(res)


def forecast_for_time(rdd, lat, long, date, time, h_distance, h_date, h_time):
    ### CALCULATE GAUSSIAN KERNELS
    # map as
    # (date_kernel, time_kernel, distance_kernel, temperature)
    kernels = rdd.\
        map(lambda x: (\
            gaussian_kernel(h_date, dates_diff(date, x[1][0])),\
            gaussian_kernel(h_time, time_diff(time, x[1][1])),\
            gaussian_kernel(h_distance, haversine(long, lat, x[2][1], x[2][0])),\
            float(x[1][2])))

    ### CALCULATE THE FINAL KERNEL
    # map as
    # (kernel, temperature)
    sum_kernel = kernels.\
        map(lambda x: (\
            x[0] + x[1] + x[2],\
            x[3]))

    ### PREDICTION FROM KERNEL
    # map as (time, (kernel*temp, kernel))
    # reduce by key and sum all of the values
    # map as (time, sum(kernel*temp)/sum(kernel)) ### prediction for specific time
    pred = sum_kernel.\
        map(lambda x: (time, (x[0]*x[1], x[0]))).\
        reduceByKey(lambda x, y: (x[0]+y[0], x[1]+y[1])).\
        map(lambda x: (time, x[1][0]/x[1][1]))
    return pred.collect()[0]
