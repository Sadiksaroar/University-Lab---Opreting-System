#!/bin/bash

# Function to read integer input
read_int() {
  local input
  read input
  while ! [[ "$input" =~ ^[0-9]+$ ]]; do
    echo "Invalid input, please enter an integer."
    read input
  done
  echo $input
}

# Read the number of blocks
echo -n "Enter the number of Blocks − "
num_blocks=$(read_int)

# Array to store block sizes
declare -a block_sizes
declare -a block_status  # 0 if free, 1 if allocated

# Read block sizes
for ((i=0; i<num_blocks; i++)); do
  echo -n "Block $((i + 1)) size: "
  block_sizes[i]=$(read_int)
  block_status[i]=0  # Initialize all blocks as free
done

# Read the number of processes
echo -n "Enter the number of processes − "
num_processes=$(read_int)

# Array to store memory required for each process
declare -a process_memory
declare -a process_allocation  # -1 if not allocated, else block number

# Read memory required for each process
for ((i=0; i<num_processes; i++)); do
  echo -n "Enter memory required for process $((i + 1)) − "
  process_memory[i]=$(read_int)
  process_allocation[i]=-1  # Initialize all processes as not allocated
done

# First-fit memory allocation
for ((i=0; i<num_processes; i++)); do
  for ((j=0; j<num_blocks; j++)); do
    if ((block_status[j] == 0 && process_memory[i] <= block_sizes[j])); then
      process_allocation[i]=$j
      block_status[j]=1
      break
    fi
  done
done

# Output results
echo -e "\nOUTPUT:"
echo "Block sizes: ${block_sizes[*]}"
echo "Process memory requirements: ${process_memory[*]}"
echo -e "\nPROCESS\tMEMORY REQUIRED\tBLOCK ALLOCATED"

for ((i=0; i<num_processes; i++)); do
  if ((process_allocation[i] == -1)); then
    echo -e "$((i + 1))\t${process_memory[i]}\t\tNot Allocated"
  else
    echo -e "$((i + 1))\t${process_memory[i]}\t\t$((process_allocation[i] + 1))"
  fi
done

# Calculate external fragmentation
external_fragmentation=0
for ((j=0; j<num_blocks; j++)); do
  if ((block_status[j] == 0)); then
    external_fragmentation=$((external_fragmentation + block_sizes[j]))
  fi
done

echo "Total External Fragmentation is $external_fragmentation"
