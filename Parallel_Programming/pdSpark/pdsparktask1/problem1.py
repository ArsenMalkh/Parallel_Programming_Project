from pyspark import SparkContext, SparkConf 
import re

conf = SparkConf().setAppName("problem1").setMaster("yarn") 
spark_context = SparkContext(conf=conf) 

rdd = spark_context.textFile("/data/wiki/en_articles_part") 
rdd = rdd.map(lambda x: x.strip().lower()) 

rdd = rdd.map(lambda x: re.sub("narodnaya\W+", "narodnaya_", x)) 
rdd = rdd.flatMap(lambda x: x.split(" "))
rdd = rdd.map(lambda x: re.sub("^\W+|\W+$", "", x)) 
rdd = rdd.filter(lambda x: "narodnaya" in x) 
rdd = rdd.map(lambda x: (x, 1)) 
rdd = rdd.reduceByKey(lambda x, y: x + y)
rdd = rdd.sortByKey(ascending=True) 

words = rdd.collect()
for word, count in words:
    print word, count
