ADD JAR /opt/cloudera/parcels/CDH/lib/hive/lib/hive-contrib.jar;
ADD jar /opt/cloudera/parcels/CDH/lib/hive/lib/hive-serde.jar;
USE malhasjanar;

SET hive.exec.dynamic.partition.mode=nonstrict;
SET hive.exec.max.dynamic.partitions=1000000;
SET hive.exec.max.dynamic.partitions.pernode=1000000;

SELECT date, count(date) as counts FROM Logs
GROUP BY date
ORDER BY counts DESC;
