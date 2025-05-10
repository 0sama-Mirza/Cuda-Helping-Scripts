#!/bin/bash

# Script to compile a CUDA and MPI program
# Usage: ./compile_cuda_mpi.sh <source_file.cu> [output_file_name]

# Check if at least one argument is provided
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <source_file.cu> [output_file_name]"
    exit 1
fi

# Input source file
SOURCE_FILE=$1

# Set output file name based on the source file if not provided
if [ "$#" -ge 2 ]; then
    OUTPUT_FILE=$2
else
    OUTPUT_FILE=${SOURCE_FILE%.cu}
fi

# CUDA and MPI flags
CUDA_FLAGS="-L/usr/local/cuda/lib64 -lcudart -I/usr/local/cuda/include"
MPI_FLAGS="-L/usr/local/lib/openmpi -lmpi"

# Specify the compiler for CUDA
COMPILER_BIN_DIR="--compiler-bindir /usr/bin/g++-8"

# Construct the compilation command
COMPILE_COMMAND="nvcc -v -arch=sm_50 $SOURCE_FILE -o $OUTPUT_FILE $CUDA_FLAGS $MPI_FLAGS $COMPILER_BIN_DIR"

# Print the command that will be executed
echo "Compiling with command:"
echo "$COMPILE_COMMAND"

# Execute the command
$COMPILE_COMMAND

# Check if compilation was successful
if [ $? -eq 0 ]; then
    echo "Compiled $SOURCE_FILE into $OUTPUT_FILE successfully."
else
    echo "Compilation failed."
    exit 1
fi

