#!/usr/bin/env python

import sys
import random

for iden_id in sys.stdin:
    try:
        strip_Id  = iden_id.strip();
    except ValueError as e:
        continue
    print "%d\t%s" % (random.randint(1,999), strip_Id)
