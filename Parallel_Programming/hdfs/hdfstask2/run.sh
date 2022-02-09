#!/usr/bin/env bash

file=${1}
address="http://mipt-master.atp-fivt.org:50070/webhdfs/v1${file}?op=OPEN&length=10"

tail_10=$(curl -i -L ${address} | tail -c 10)

echo ${tail_10}
