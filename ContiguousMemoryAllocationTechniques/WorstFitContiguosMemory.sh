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
echo -n "Enter the number of blocks: "
nb=$(read_int)

# Read the number of files
echo -n "Enter the number of files: "
nf=$(read_int)

# Initialize arrays and variables
declare -a b
declare -a f
declare -a frag
declare -a bf
declare -a ff

# Read the size of each block
echo "Enter the size of the blocks: "
for ((i=1; i<=nb; i++)); do
  echo -n "Block $i: "
  b[i]=$(read_int)
  bf[i]=0  # Initialize block allocation status as free
done

# Read the size of each file
echo "Enter the size of the files: "
for ((i=1; i<=nf; i++)); do
  echo -n "File $i: "
  f[i]=$(read_int)
done

# Memory allocation using Worst-Fit algorithm
for ((i=1; i<=nf; i++)); do
  highest=-1
  block_index=-1
  for ((j=1; j<=nb; j++)); do
    if [[ ${bf[j]} -eq 0 ]]; then
      temp=$((b[j] - f[i]))
      if [[ $temp -ge 0 && $temp -gt $highest ]]; then
        highest=$temp
        block_index=$j
      fi
    fi
  done
  if [[ $block_index -ne -1 ]]; then
    ff[i]=$block_index
    frag[i]=$highest
    bf[block_index]=1
  else
    ff[i]=-1  # Indicate that the file was not allocated
    frag[i]=0  # No fragmentation if not allocated
  fi
done

# Output results
echo -e "\nFile_no\tFile_size\tBlock_no\tBlock_size\tFragment"
for ((i=1; i<=nf; i++)); do
  if [[ ${ff[i]} -ne -1 ]]; then
    echo -e "$i\t\t${f[i]}\t\t${ff[i]}\t\t${b[ff[i]]}\t\t${frag[i]}"
  else
    echo -e "$i\t\t${f[i]}\t\tNot Allocated\t\t\t"
  fi
done
