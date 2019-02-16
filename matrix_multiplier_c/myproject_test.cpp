//
//    rfnoc-hls-neuralnet: Vivado HLS code for neural-net building blocks
//
//    Copyright (C) 2017 EJ Kreinar
//
//    This program is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
#include <fstream>
#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <vector>

#include "firmware/matrix_multiplier.h"

#define TESTBENCH_INPUT_A "tb_data/tb_input_A_features.dat"
#define TESTBENCH_INPUT_B "tb_data/tb_input_B_features.dat"
#define TESTBENCH_OUTPUT_PREDICTION "tb_data/tb_output_predictions.dat"
#define TESTBENCH_INPUT_A_SIZE NROWS_A*NCOLS_A*NSTREAM
#define TESTBENCH_INPUT_B_SIZE NROWS_B*NCOLS_B*NSTREAM
#define TESTBENCH_OUTPUT_SIZE NROWS_A*NCOLS_B*NSTREAM

int main( int argc, char **argv )
{

    //load input data from text file
    std::ifstream fin_A( TESTBENCH_INPUT_A );
    std::ifstream fin_B( TESTBENCH_INPUT_B );

    //load predictions from text file
    std::ifstream fpr( TESTBENCH_OUTPUT_PREDICTION );

    std::string iline_A;
    std::string iline_B;
    std::string pline;

    if ( fin_A.is_open( ) && fin_B.is_open( ) && fpr.is_open( ) )
    {

        // The input and result object pointer
        // The input data is unrolled in to a single dimension array
        // Say, index of ijk refers to (row=i, col=j, evt=k) for a m x n matrix then the numbers are stored as
        // [ 111, 121, 131, ..., 1(n-1)1, 1n1, 211, 221, 231, ..., 2(n-1)1, 2n1, ... , (m-1)(n-1)1, (m-1)n1, m11, ..., mn1, mn2, ... ]
        my_data_t* in_A_str = new my_data_t[TESTBENCH_INPUT_A_SIZE];
        my_data_t* in_B_str = new my_data_t[TESTBENCH_INPUT_B_SIZE];
        my_data_t* out_str = new my_data_t[TESTBENCH_OUTPUT_SIZE];


        // Input vector that is used to temporary hold before pushing into in_A_str, in_B_str
        std::vector<float> in_A;
        std::vector<float> in_B;

        // Prediction vector
        std::vector<float> prediction;

        // Create output file where the results will be stored
        std::ofstream fout;
        fout.open( "tb_output_data.dat" );

        // Now loop over the input files and store them into a giant array of numbers
        int evt = 0;
        int block = 0;
        while ( std::getline( fin_A, iline_A ) && std::getline( fin_B, iline_B ) && std::getline( fpr, pline ) )
        {

            if ( evt >= NDATA )
                break;

            // Parse input data matrix A
            char* cstr = const_cast<char*>( iline_A.c_str( ) );
            char* current;
            current = strtok( cstr, " " );
            while ( current != NULL )
            {
                in_A.push_back( atof( current ) );
                current = strtok( NULL, " " );
            }

            // Parse input data matrix B
            cstr = const_cast<char*>( iline_B.c_str( ) );
            current = strtok( cstr, " " );
            while ( current != NULL )
            {
                in_B.push_back( atof( current ) );
                current = strtok( NULL, " " );
            }

            // Parse prediction (i.e. the true correct results)
            cstr = const_cast<char*>( pline.c_str( ) );
            current = strtok( cstr, " " );
            while ( current != NULL )
            {
                prediction.push_back( atof( current ) );
                current = strtok( NULL, " " );
            }

            evt++;
            block++;

            // If pushed NSTREAM number of inputs, compute and reset
            if ( block >= NSTREAM )
            {

                // Push the input into giant array
                for ( unsigned int ii = 0; ii < in_A.size(); ++ii) { in_A_str[ii] = in_A[ii]; }
                for ( unsigned int ii = 0; ii < in_B.size(); ++ii) { in_B_str[ii] = in_B[ii]; }

                matrix_multiplier( in_A_str, in_B_str, out_str );

                for ( int iblock = 0; iblock < NSTREAM; iblock++ )
                {

                    std::cout << "Predictions" << std::endl;

                    for ( int ii = 0; ii < NROWS_A * NCOLS_B; ii++ )
                    {
                        std::cout << prediction[iblock * NROWS_A * NCOLS_B + ii] << " ";
                    }

                    std::cout << std::endl;

                    std::cout << "Quantized predictions" << std::endl;

                    for ( int ii = 0; ii < NROWS_A * NCOLS_B; ii++ )
                    {
                        std::cout << out_str[iblock * NROWS_A * NCOLS_B + ii] << " ";
                    }

                    std::cout << std::endl;

                }

                block = 0;
                prediction.clear();
                in_A.clear();
                in_B.clear();
            }

        }

        fin_A.close();
        fin_B.close();
        fpr.close();
        fout.close();

    }
    else
    {
        std::cout << "Unable to open input/predictions file" << std::endl;
    }

    return 0;
}
