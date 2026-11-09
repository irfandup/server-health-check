#!/bin/bash

hostname=$(hostname -f)
uptime=$(uptime)
cpu=$(echo $((100-$(vmstat 1 2 | tail -1 | awk '{print $15}'))))
ram=$(free | grep Mem | awk '{printf "%.2f%%\n", $3/$2 * 100}')
disk=$(df -h / | tail -n 1 | awk '{print $5}')
disk_usage=${disk%\%}

check_network() {
if ping -c 1 -W 2 8.8.8.8 > /dev/null; then
	echo "Network: OK"
else
	echo "Network: FAILED"
fi
}
check_cpu() {
if [[ $cpu -ge 80 ]]; then
       printf "CPU Usage: %d%% [WARNING]\n" $cpu
else
       printf "CPU Usage: %d%% [HEALTHY]\n" $cpu
fi
}
check_disk() {
if [[ $disk_usage -ge 80 ]]; then
       echo "Disk Usage: $disk [WARNING]"
else
       echo "Disk Usage: $disk [HEALTHY]"
fi

}

printf "=========SERVER HEALTH CHECK=========\n"

echo "Hostname: $hostname"
echo "Uptime: $uptime"
echo "Cpu: $cpu%"
echo "RAM: $ram"
echo "Disk: $disk"

check_network
check_cpu
check_disk
