#!/bin/bash
module add mpi/openmpi4-x86_64
mpic++ main.cpp
python3 script.py