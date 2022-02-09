#!/usr/bin/env bash

str='DatanodeInfoWithStorage\[[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}'
ip=$(hdfs fsck $1 -files -blocks -locations | grep -E -o ${str} | head -1)

echo ${ip:24}
