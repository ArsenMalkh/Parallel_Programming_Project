#!/usr/bin/env python

import sys
import random

str_line = ""
cnt_line = random.randint(1,5)

for line in sys.stdin:
    try:
        count, Id = line.strip().split('\t', 1)
    except ValueError as e: 
        continue
    if cnt_line > 1:
        str_line += Id + ","
        cnt_line -= 1
    else:
        str_line += Id;
        print (str_line)
        cnt_line = random.randint(1,5)
        str_line = ""

if str_line != "":
    print(str_line.strip(','))
