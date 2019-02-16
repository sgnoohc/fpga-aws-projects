#!/bin/env python

import random
import sys

inputs = []
for n in range(4096):
    mm = []
    for i in range(256):
        mm.append("{:.4f}".format(random.uniform(0, 1)))
    inputs.append(mm)

f = open(sys.argv[1], "w")

for mm in inputs:
    f.write(" ".join(mm) + "\n")
