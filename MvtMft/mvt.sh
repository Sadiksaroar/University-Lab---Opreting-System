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

# Read the total memory size
echo -n "Enter the total memory available (in Bytes) −− "
ms=$(read_int)

# Read the block size
echo -n "Enter the block size (in Bytes) −− "
bs=$(read_int)

# Calculate the number of blocks and external fragmentation
nob=$((ms / bs))
ef=$((ms - nob * bs))

# Read the number of processes
echo -n "Enter the number of processes −− "
n=$(read_int)

# Array to store memory required for each process
declare -a mp

# Read memory required for each process
for ((i=0; i<n; i++)); do
  echo -n "Enter memory required for process $((i + 1)) (in Bytes) −− "
  mp[i]=$(read_int)
done

# Print the number of blocks available
echo -e "\nNo. of Blocks available in memory −− $nob"

# Print the header for the process table
echo -e "\nPROCESS\tMEMORY REQUIRED\tALLOCATED\tINTERNAL FRAGMENTATION"

# Variables for internal fragmentation and process counter
tif=0
p=0

# Process each process
for ((i=0; i<n && p<nob; i++)); do
  echo -n -e "$((i + 1))\t\t${mp[i]}"
  
  if ((mp[i] > bs)); then
    echo -e "\t\t NO\t\t−−−"
  else
    internal_frag=$((bs - mp[i]))
    echo -e "\t\t YES\t\t$internal_frag"
    tif=$((tif + internal_frag))
    p=$((p + 1))
  fi
done

# Check if there are remaining processes that cannot be accommodated
if ((i < n)); then
  echo -e "\n\nMemory is Full, Remaining Processes cannot be accommodated"
fi

# Print total internal and external fragmentation
echo -e "\n\nTotal Internal Fragmentation is $tif"
echo -e "Total External Fragmentation is $ef"
