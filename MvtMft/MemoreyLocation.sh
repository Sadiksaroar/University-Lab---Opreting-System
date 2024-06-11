#!/bin/bash

# Initialize total memory
echo -n "Enter the total memory available (in Bytes) − "
read total_memory

# Initialize variables
available_memory=$total_memory
process_count=0
declare -a memory_allocated

while true; do
  echo -n "Enter memory required for process $((process_count + 1)) (in Bytes) − "
  read required_memory

  # Check if there is enough available memory
  if (( required_memory <= available_memory )); then
    # Allocate memory
    memory_allocated[process_count]=$required_memory
    available_memory=$((available_memory - required_memory))
    echo "Memory is allocated for Process $((process_count + 1))"
    process_count=$((process_count + 1))
  else
    echo "Memory is Full"
    break
  fi

  # Ask if the user wants to continue
  echo -n "Do you want to continue(y/n): "
  read response
  if [[ "$response" != "y" ]]; then
    break
  fi
done

# Output results
echo -e "\nOUTPUT:"
echo "Total Memory Available − $total_memory"
echo -e "PROCESS\tMEMORY ALLOCATED"
total_allocated_memory=0
for ((i=0; i<process_count; i++)); do
  echo -e "$((i + 1))\t${memory_allocated[i]}"
  total_allocated_memory=$((total_allocated_memory + memory_allocated[i]))
done
echo "Total Memory Allocated is $total_allocated_memory"
echo "Total External Fragmentation is $available_memory"
