#!/bin/bash

hostname=$(hostname -f)
uptime=$(uptime)
cpu=$(echo $[100-$(vmstat 1 2 | tail -1 | awk '{print $15}')])
ram=$(free | grep Mem | awk '{printf "%.2f%%\n", $3/$2 * 100}')
disk=$(df -h / | tail -n 1 | awk '{print $5}')


echo "=================\n SERVER HEALTH CHECK\n ====================\n"

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
