import os
import csv
import time
import subprocess


template='''#!/bin/bash 
#
CUDA_VISIBLE_DEVICES=5 {} {} {}'''

out_file = open("table_out.txt", "a")
N_values = [2**12, 2**16, 2**18, 2**22,  2**24, 2**28]
N_files = ["./../build/01-add", "./../build/02-mul", "./../build/03-matrix-add", "./../build/04-matrix-vector-mul"]
blockSize = 256;
for files in N_files:
    for N in N_values:
        with open("run.sh", "w") as script:
            script.write(template.format(files, N, blockSize))
        os.system("bash run.sh")
        time.sleep(8);
        with open("out.txt", "r") as out:
            temp = out.read()
            out_file.write("{} {}".format(files, temp))
        os.system("rm out.txt")
out_file.close()
