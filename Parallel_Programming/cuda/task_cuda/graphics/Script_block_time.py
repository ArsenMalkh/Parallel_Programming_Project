import os
import csv
import time
import subprocess


template='''#!/bin/bash 
#
CUDA_VISIBLE_DEVICES=5 {} {} {}'''

out_file = open("table_block_time.txt", "a")
Block_values = [2**4, 2**5, 2**6, 2**7,  2**8, 2**10]
N_files = ["./../build/01-add", "./../build/02-mul", "./../build/03-matrix-add", "./../build/04-matrix-vector-mul"]
N = 2**28;
for files in N_files:
    for blockSize in Block_values:
        with open("run.sh", "w") as script:
            script.write(template.format(files, N, blockSize))
        os.system("bash run.sh")
        time.sleep(7);
        with open("out.txt", "r") as out:
            temp = out.read()
            out_file.write("{} {}".format(files, temp))
        os.system("rm out.txt")
out_file.close()

