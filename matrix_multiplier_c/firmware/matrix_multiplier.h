//  .
// ..: Philip Chang, Univ. California San Diego <philip@ucsd.edu>

// matrix multiplier: Vivado HLS code for matrix multiplication

#ifndef MATRIX_MULTIPLIER_H
#define MATRIX_MULTIPLIER_H

#include "ap_fixed.h"

typedef ap_fixed<16,6> my_data_t;

#define NROWS_A 16
#define NCOLS_A 16
#define NROWS_B NCOLS_A
#define NCOLS_B 16
#define NDATA 4096
#define NSTREAM 8

// Prototype of top level function for C-synthesis
void matrix_multiplier(
        my_data_t in_A[NSTREAM][NROWS_A * NCOLS_A],
        my_data_t in_B[NSTREAM][NROWS_B * NCOLS_B],
        my_data_t out [NSTREAM][NROWS_A * NCOLS_B]
        );

void do_one_matrix_multiplication(
        my_data_t in_A_one_evt[NROWS_A * NCOLS_A],
        my_data_t in_B_one_evt[NROWS_B * NCOLS_B],
        my_data_t out_one_evt[NROWS_A * NCOLS_B]
        );


#endif

