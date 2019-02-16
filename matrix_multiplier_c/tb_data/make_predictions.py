#!/bin/env python

import sys
import os

fin_A = open("tb_input_A_features.dat")
fin_B = open("tb_input_B_features.dat")
fout = open(sys.argv[1], "w")

inputs_A = [ [ float(x) for x in line.strip().split() ] for line in fin_A.readlines() ]
inputs_B = [ [ float(x) for x in line.strip().split() ] for line in fin_B.readlines() ]

# for in_A in inputs_A:
#     print(in_A)
# for in_B in inputs_B:
#     print(in_B)

out = []
for ii in range(256):
    out.append(0)

for in_A, in_B in zip(inputs_A, inputs_B):
    for ii in range(16):
        for jj in range(16):
            for kk in range(16):
                index_A = ii * 16 + kk
                index_B = kk * 16 + jj
                index_C = ii * 16 + jj
                if kk == 0:
                    out[ii * 16 + jj] = in_A[index_A] * in_B[index_B]
                else:
                    out[ii * 16 + jj] += in_A[index_A] * in_B[index_B]
    str_out = [ "{:.4f}".format(o) for o in out ]
    fout.write(" ".join(str_out) + "\n")
