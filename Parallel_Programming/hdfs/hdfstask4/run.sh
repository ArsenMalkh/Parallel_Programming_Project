#!/usr/bin/env bash

node=$(hdfs fsck -blockId ${1} | grep -E -o "mipt-node[[:digit:]]+.atp-fivt.org" | tail -1)
address="hdfsuser@${node}"
path=$(sudo -u hdfsuser ssh ${address} find /dfs/ -name ${1})
echo "${node}:${path}"
