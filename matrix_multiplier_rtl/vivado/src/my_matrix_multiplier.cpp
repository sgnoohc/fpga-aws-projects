// This is a generated file. Use and modify at your own risk.
////////////////////////////////////////////////////////////////////////////////

//-----------------------------------------------------------------------------
// kernel: my_matrix_multiplier
//
// Purpose: This kernel example shows a basic vector add +1 (constant) by
//          manipulating memory inplace.
//-----------------------------------------------------------------------------
#define BUFFER_SIZE 8192
#include <string.h>
#include <stdbool.h>
#include "hls_half.h"

// Do not modify function declaration
extern "C" void my_matrix_multiplier (
    unsigned int nrows_A,
    unsigned int ncols_A,
    unsigned int ncols_B,
    int* in_A,
    int* in_B,
    int* out_C
) {

    #pragma HLS INTERFACE m_axi port=in_A offset=slave bundle=m00_axi
    #pragma HLS INTERFACE m_axi port=in_B offset=slave bundle=m01_axi
    #pragma HLS INTERFACE m_axi port=out_C offset=slave bundle=m02_axi
    #pragma HLS INTERFACE s_axilite port=nrows_A bundle=control
    #pragma HLS INTERFACE s_axilite port=ncols_A bundle=control
    #pragma HLS INTERFACE s_axilite port=ncols_B bundle=control
    #pragma HLS INTERFACE s_axilite port=in_A bundle=control
    #pragma HLS INTERFACE s_axilite port=in_B bundle=control
    #pragma HLS INTERFACE s_axilite port=out_C bundle=control
    #pragma HLS INTERFACE s_axilite port=return bundle=control

// Modify contents below to match the function of the RTL Kernel
    int i = 0;

    // Create input and output buffers for interface m00_axi
    int m00_axi_input_buffer[BUFFER_SIZE];
    int m00_axi_output_buffer[BUFFER_SIZE];


    // length is specified in number of words.
    unsigned int m00_axi_length = 4096;


    // Assign input to a buffer
    memcpy(m00_axi_input_buffer, (int*) in_A, m00_axi_length*sizeof(int));

    // Add 1 to input buffer and assign to output buffer.
    for (i = 0; i < m00_axi_length; i++) {
      m00_axi_output_buffer[i] = m00_axi_input_buffer[i]  + 1;
    }

    // assign output buffer out to memory
    memcpy((int*) in_A, m00_axi_output_buffer, m00_axi_length*sizeof(int));


    // Create input and output buffers for interface m01_axi
    int m01_axi_input_buffer[BUFFER_SIZE];
    int m01_axi_output_buffer[BUFFER_SIZE];


    // length is specified in number of words.
    unsigned int m01_axi_length = 4096;


    // Assign input to a buffer
    memcpy(m01_axi_input_buffer, (int*) in_B, m01_axi_length*sizeof(int));

    // Add 1 to input buffer and assign to output buffer.
    for (i = 0; i < m01_axi_length; i++) {
      m01_axi_output_buffer[i] = m01_axi_input_buffer[i]  + 1;
    }

    // assign output buffer out to memory
    memcpy((int*) in_B, m01_axi_output_buffer, m01_axi_length*sizeof(int));


    // Create input and output buffers for interface m02_axi
    int m02_axi_input_buffer[BUFFER_SIZE];
    int m02_axi_output_buffer[BUFFER_SIZE];


    // length is specified in number of words.
    unsigned int m02_axi_length = 4096;


    // Assign input to a buffer
    memcpy(m02_axi_input_buffer, (int*) out_C, m02_axi_length*sizeof(int));

    // Add 1 to input buffer and assign to output buffer.
    for (i = 0; i < m02_axi_length; i++) {
      m02_axi_output_buffer[i] = m02_axi_input_buffer[i]  + 1;
    }

    // assign output buffer out to memory
    memcpy((int*) out_C, m02_axi_output_buffer, m02_axi_length*sizeof(int));


}

