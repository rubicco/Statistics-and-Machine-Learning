# - *- coding: utf- 8 - *-
# set year filter boundaries
lower_year = 1950
upper_year = 2014
# create empty dictionary for our response
response_max = {year:-10000 for year in range(lower_year,upper_year+1)}
# response_min = {year:10000 for year in range(lower_year,upper_year+1)}

line_no = 0
# read file
with open("../station_data/short_temperature_reads.csv","r") as file:
    # with open("/nfshome/hadoop_examples/shared_data/temperatures-big.csv","r") as file:
    for line in file:
        # We split the line by ; symbol.
        # after spliting er get the format as following:
        # ["station_no", "yyyy-mm-dd", "hh:mm:ss", "temp", "G new_line"]
        # we will check years and find the max and min of each year
        if not line_no%10000:
            print(line_no)
        line_no += 1
        reading = line.split(";")
        year = int(reading[1][0:4])
        # check our filter
        if year > 1950 and year < 2014:
            temp = float(reading[3])
            if temp > response_max[year]:
                response_max[year] = temp
            # if temp < response_min[year]:
            #     response_min[year] = temp

end = time.time()

print "RUNTIME = {}".format(end-start)
with open("task1b_nonparallel_time.out","w") as file:
	file.write("RUNTIME = {}".format(end-start))            

with open("t1b_max_stations", "w") as file:
    for k in response_max.keys():
        file.write("%s: %s\n" % (k, response_max[k]))

# with open("t1b_min_stations", "w") as file:
#     for k in response_max.keys():
#         file.write("%s: %s\n" % (k, response_min[k]))
