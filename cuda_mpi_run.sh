#!/bin/bash

# Check if the user has provided a program name
if [ -z "$1" ]; then
    echo "Error: Please provide the program to run (e.g., ./cuda_mpi_run.sh Task1)"
    exit 1
fi

# Assign the program to a variable
program_path="$1"

# Check if the program exists
if [ ! -f "$program_path" ]; then
    echo "Error: Program '$program_path' not found!"
    exit 1
fi

# Get the number of available CPU cores (this will help for the "Fewer Processes" option)
max_cores=$(nproc)

# Ask the user for input on how they want to run the program
echo "How would you like to run the program?"
echo "1) Run with Hyperthreading"
echo "2) Allow Oversubscription"
echo "3) Run with Fewer Processes (2 Processes or more)"

# Read user input
read -p "Enter your choice (1/2/3): " choice

# Set the CUDA_VISIBLE_DEVICES environment variable (can be modified based on the user's system)
cuda_devices="0,1,2,3"  # This can be changed based on available GPUs

# Execute the selected option
case $choice in
    1)
        echo "Running with Hyperthreading..."
        # Set the number of processes to the number of available CPU cores
        num_processes=$max_cores
        command="mpirun -np $num_processes -x CUDA_VISIBLE_DEVICES=$cuda_devices --use-hwthread-cpus $program_path"
        echo "Executing command: $command"
        eval $command
        ;;
    2)
        echo "Allowing Oversubscription..."
        # Set the number of processes to the number of available CPU cores
        num_processes=$max_cores
        command="mpirun -np $num_processes -x CUDA_VISIBLE_DEVICES=$cuda_devices --oversubscribe $program_path"
        echo "Executing command: $command"
        eval $command
        ;;
    3)
        # Ask for how many processes the user wants to run (within the available core limit)
        echo "Your system has a maximum of $max_cores CPU cores."
        read -p "Enter the number of processes to run (up to $max_cores): " num_processes

        # Ensure the number of processes doesn't exceed available cores
        if [ "$num_processes" -gt "$max_cores" ]; then
            echo "Error: The number of processes cannot exceed $max_cores."
            exit 1
        fi

        echo "Running with $num_processes processes..."
        command="mpirun -np $num_processes -x CUDA_VISIBLE_DEVICES=$cuda_devices $program_path"
        echo "Executing command: $command"
        eval $command
        ;;
    *)
        echo "Invalid choice. Please select 1, 2, or 3."
        exit 1
        ;;
esac

