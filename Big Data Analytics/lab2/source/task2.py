# import libraries
from pyspark import SparkContext
from pyspark.sql import SQLContext, Row
from pyspark.sql import functions as F

# create Contexts
sc = SparkContext()
sqlContext = SQLContext(sc)

# Load a text file and convert each line to a tuple.
# temperature_file = sc.textFile("../station_data/short_temperature_reads.csv")
# temperature_file = sc.textFile("/user/x_mimte/data/temperatures-big.csv")
temperature_file = sc.textFile("/user/x_mimte/data/temperature-readings.csv")

# transform the data by splitting each line
lines = temperature_file. \
    map(lambda line: line.split(";"))

# define headers of the dataframe
tempReadingsString= ["station", "date", "year", "month", "time", "value", "quality"]

# map the data for our headers
# ['103100', '1996-07-06', '15:00:00', '14.8', 'G']
tempReadingsRow = lines.map(lambda line: (line[0], line[1], int(line[1][0:4]), \
                            int(line[1][5:7]), line[2], \
                            float(line[3]), line[4]))

# Apply the schema to the RDD.
schemaTempReadings = sqlContext.createDataFrame(tempReadingsRow, tempReadingsString)
schemaTempReadings.registerTempTable("tempReadingsTable")



############
#####   2.i & ii with API
############
counts_monthly_api = schemaTempReadings.\
    where("value>=10 and year>=1950 and year<=2014").\
    groupby("year", "month").\
    agg(F.count("value").alias("count")).\
    orderBy("count", ascending=False)
    # orderBy("count", ascending=False)

counts_monthly_distinct_api = schemaTempReadings.\
    where("value>=10 and year>=1950 and year<=2014").\
    select("year", "month", "station").\
    distinct().\
    groupby("year", "month").\
    agg(F.count("station").alias("count")).\
    orderBy("count", ascending=False)
    # orderBy("count", ascending=False)

counts_monthly_api.rdd.saveAsTextFile("./bda2_res/t2_api_count_reads_month")
counts_monthly_distinct_api.rdd.saveAsTextFile("./bda2_res/t2_api_count_reads_month_distinct")

############
#####   2.i & ii with SQL
############

q1 ="select year, month, count(value) as count \
from tempReadingsTable \
where value>=10 and year between 1950 and 2014 \
group by year, month \
order by count desc"
# order by count desc"

q2 = "SELECT year, month, count(station) as count \
FROM (SELECT distinct year, month, station \
FROM tempReadingsTable \
WHERE value >= 10 and year BETWEEN 1950 AND 2014) AS Q \
group by year, month \
order by count desc"
# order by count desc"

counts_monthly = sqlContext.sql(q1)

counts_monthly_distinct = sqlContext.sql(q2)

counts_monthly.rdd.saveAsTextFile("./bda2_res/t2_sql_count_reads_month")
counts_monthly_distinct.rdd.saveAsTextFile("./bda2_res/t2_sql_count_reads_month_distinct")
