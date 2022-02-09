ADD JAR /opt/cloudera/parcels/CDH/lib/hive/lib/hive-contrib.jar;
ADD jar /opt/cloudera/parcels/CDH/lib/hive/lib/hive-serde.jar;
ADD FILE modif.py;
USE malhasjanar;

SET hive.exec.dynamic.partition.mode=nonstrict;
SET hive.exec.max.dynamic.partitions=1000000;
SET hive.exec.max.dynamic.partitions.pernode=1000000;

SELECT Transform(ip)
using 'python3 modif.py' as ip FROM Subnets LIMIT 10;
