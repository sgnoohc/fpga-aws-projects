//  .
// ..: Philip Chang, Univ. California San Diego <philip@ucsd.edu>

// matrix multiplier: Vivado HLS code for matrix multiplication

#include <iostream>

#include "matrix_multiplier.h"

void matrix_multiplier(
        my_data_t in_A[NSTREAM][NROWS_A * NCOLS_A],
        my_data_t in_B[NSTREAM][NROWS_B * NCOLS_B],
        my_data_t out [NSTREAM][NROWS_A * NCOLS_B]
        )
{
    #pragma HLS ARRAY_RESHAPE variable=in_A cyclic dim=1 
    #pragma HLS ARRAY_RESHAPE variable=in_B cyclic dim=1 
    #pragma HLS ARRAY_RESHAPE variable=out cyclic dim=1
    #pragma HLS INTERFACE ap_fifo port=in_A,in_B,out 
    #pragma HLS PIPELINE II=NCOLS_A // In matrix multiplication of MxN * NxP, N is the absolute minimal clock cycle since this function locks the memory, you can't pipeline any further, 

    // Copy one event worth
    my_data_t in_A_one_evt[NROWS_A * NCOLS_A];
    #pragma HLS ARRAY_PARTITION variable=in_A_one_evt complete dim=0
    my_data_t in_B_one_evt[NROWS_B * NCOLS_B];
    #pragma HLS ARRAY_PARTITION variable=in_B_one_evt complete dim=0
    my_data_t out_one_evt[NROWS_A * NCOLS_B];
    #pragma HLS ARRAY_PARTITION variable=out_one_evt complete dim=0

    EVENTS:
    for ( int evt = 0; evt < NSTREAM; ++evt)
    {
        // Set inputs
        for ( int ii = 0; ii < NROWS_A * NCOLS_A; ++ii) in_A_one_evt[ii] = in_A[evt * NROWS_A * NCOLS_A + ii];
        for ( int ii = 0; ii < NROWS_B * NCOLS_B; ++ii) in_B_one_evt[ii] = in_B[evt * NROWS_B * NCOLS_B + ii];

        // Do calculation
        do_one_matrix_multiplication(in_A_one_evt, in_B_one_evt, out_one_evt);

        // Aggregate outputs
        for ( int ii = 0; ii < NROWS_A * NCOLS_B; ++ii) out[evt * NROWS_A * NCOLS_B + ii] = out_one_evt[ii];
    }

}

void do_one_matrix_multiplication(
        my_data_t in_A[NROWS_A * NCOLS_A],
        my_data_t in_B[NROWS_B * NCOLS_B],
        my_data_t out[NROWS_A * NCOLS_B]
        )
{
    #pragma HLS PIPELINE
    #pragma HLS ARRAY_PARTITION variable=in_A
    #pragma HLS ARRAY_PARTITION variable=in_B
    #pragma HLS ARRAY_PARTITION variable=out
    ROW:
    for ( int ii = 0; ii < NROWS_A; ++ii)
    {
        COL:
        for ( int jj = 0; jj < NCOLS_B; ++jj)
        {
            INTER:
            for ( int kk = 0; kk < NCOLS_A; ++kk)
            {
                int index_A = ii * NCOLS_A + kk;
                int index_B = kk * NROWS_B + jj;
                int index_C = ii * NCOLS_B + jj;

                // So that when it's the first element of series of addition, it is effectively reset
                if (kk == 0)
                    out[index_C] = in_A[index_A] * in_B[index_B];
                else
                    out[index_C] += in_A[index_A] * in_B[index_B];
                // std::cout << index_A << " " << in_A[index_A] << std::endl;
                // std::cout << index_B << " " << in_B[index_B] << std::endl;
                // std::cout << ii << " " << jj << " " << index_C << " " << out[index_C] << std::endl;
            }
        }
    }
}
