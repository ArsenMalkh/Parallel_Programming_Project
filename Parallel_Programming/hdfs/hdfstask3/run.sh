#!/usr/bin/env bash

file_size=$(hdfs fsck -blocks ${1}  | grep "Total blocks" | grep -E -o "[[:digit:]]" | head -1)

echo ${file_size}
