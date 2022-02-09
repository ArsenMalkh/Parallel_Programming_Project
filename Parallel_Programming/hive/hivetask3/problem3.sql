ADD JAR /opt/cloudera/parcels/CDH/lib/hive/lib/hive-contrib.jar;
ADD jar /opt/cloudera/parcels/CDH/lib/hive/lib/hive-serde.jar;
USE malhasjanar;

SET hive.exec.dynamic.partition.mode=nonstrict;
SET hive.exec.max.dynamic.partitions=1000000;
SET hive.exec.max.dynamic.partitions.pernode=1000000;

SELECT IPRegions.region, COUNT(CASE WHEN Users.sex = 'male' THEN 0 END) as male, COUNT(CASE WHEN Users.sex = 'female' THEN 0 END) as female
FROM IPRegions INNER JOIN Users
ON IPRegions.ip = Users.ip
GROUP BY IPRegions.region;
