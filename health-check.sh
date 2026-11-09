#!/bin/bash

hostname=$(hostname -f)
uptime=$(uptime)
cpu=$(echo $((100-$(vmstat 1 2 | tail -1 | awk '{print $15}'))))
ram=$(free | grep Mem | awk '{printf "%.2f%%\n", $3/$2 * 100}')
disk=$(df -h / | tail -n 1 | awk '{print $5}')
disk_usage=${disk%\%}

printf "========="
printf "SERVER HEALTH CHECK"
printf "=========\n"

echo "Hostname: $hostname"
echo "Uptime: $uptime"
echo "Cpu: $cpu%"
echo "RAM: $ram"
echo "Disk: $disk"

if ping -c 1 -W 2 8.8.8.8 > /dev/null; then
	echo "Network: OK"
else
	echo "Network: FAILED"
fi

if [[ $disk_usage -ge 80 ]]; then
       echo "Disk Usage: $disk [WARNING]"
else
       echo "Disk Usage: $disk [HEALTHY]"
fi

if [[ $cpu -ge 80 ]]; then
       printf "CPU Usage: %d [WARNING]" $cpu
else
       printf "CPU Usage: %d [HEALTHY]" $cpu
fi
