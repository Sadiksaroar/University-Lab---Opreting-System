#!/bin/bash

# Function to calculate the waiting time and turnaround time
calculate_times() {
    local n=$1
    local -n bt=$2
    local -n wt=$3
    local -n tat=$4
    wt[0]=0
    tat[0]=${bt[0]}
    wtavg=0
    tatavg=${bt[0]}

    for ((i=1; i<n; i++)); do
        wt[i]=${tat[i-1]}
        tat[i]=$((bt[i] + wt[i]))
        wtavg=$((wtavg + wt[i]))
        tatavg=$((tatavg + tat[i]))
    done
}

# Read the number of processes
echo -n "Enter the number of processes: "
read n

# Read burst times
bt=()
for ((i=0; i<n; i++)); do
    echo -n "Enter the Burst Time for process $i: "
    read bt[i]
done

# Initialize arrays for waiting time and turnaround time
wt=()
tat=()

# Calculate times
calculate_times $n bt wt tat

# Print the process details
echo -e "\nPROCESS\t\tBURST TIME\tWAITING TIME\tTURNAROUND TIME"
for ((i=0; i<n; i++)); do
    echo -e "P$i\t\t${bt[i]}\t\t${wt[i]}\t\t${tat[i]}"
done

# Calculate and print averages
wtavg=$(echo "scale=2; $wtavg / $n" | bc)
tatavg=$(echo "scale=2; $tatavg / $n" | bc)

echo -e "\nAverage Waiting Time -> $wtavg"
echo "Average Turnaround Time -> $tatavg"
