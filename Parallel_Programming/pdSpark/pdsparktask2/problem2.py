from pyspark import SparkContext, SparkConf
import re

def parse_edge(s):
    user, follower = s.split("\t")
    return (int(user), int(follower))

def step(item):
    prev_v, path, next_v = item[0], item[1][0], item[1][1]
    path += ',' + str(next_v)
    return (next_v, path)

def complete(item):
    v, old_d, new_d = item[0], item[1][0], item[1][1]
    return (v, old_d if old_d is not None else new_d)


config = SparkConf().setAppName("problem2").setMaster("yarn")
spark_context = SparkContext(conf=config)

n = 400
edges = spark_context.textFile("/data/twitter/twitter_sample.txt").map(parse_edge)
forward_edges = edges.map(lambda e: (e[1], e[0])).partitionBy(n).persist()

begin = 12
end = 34
max_path = 400
paths = spark_context.parallelize([(begin, str(begin))]).partitionBy(n)

for i in range(max_path):
    paths = paths.join(forward_edges, n).map(step)
    count = paths.filter(lambda x: x[0] == end).count()
    if count >= 1:
        break

end, path = paths.filter(lambda x: x[0] == end).first()
print path
