arch=$(uname -a);
cpu=$(grep 'cpu cores' /proc/cpuinfo | awk '{print $4}');
vcpu=$(grep 'processor' /proc/cpuinfo | wc -l);
usedMemory=$(free --mega | grep 'Mem' | awk '{print $3}');
totalMemory=$(free --mega | grep 'Mem' | awk '{print $2}');
totalMemoryMB=$totalMemory'MB';
memoryPercentage=$(printf %.2f $(echo "($usedMemory / $totalMemory) * 100" | bc -l));
totalDiskMb=$(df -ht ext4 -m | awk '{Total=Total+$2} END{print Total}');
totalDiskGb=$(printf %.$2f $(echo "$totalDiskMb / 1000" | bc -l))'Gb';
totalUsedDiskMb=$(df -ht ext4 -m | awk '{Total=Total+$3} END{print Total}');
diskPercentage=$(printf %.2f $(echo "($totalUsedDiskMb / $totalDiskMb) * 100" | bc -l));
totalCpuLoad=$(top -n1 -b | grep 'ede-cola\|root' | awk '{Total=Total+$9} END{print Total}');
lastBoot=$(who -b | awk '{print $3" "$4}');
lvm=$(lsblk | awk '{print $6}' | grep -q 'lvm' && echo "yes" || echo "no");
activeTcp=$(grep 'TCP' /proc/net/sockstat | awk '{print $3}');
userLog=$(who -u | wc -l);
ipAddress=$(ip address | grep inet | awk '{print $2}' | head -n 3 | tail -n +3);
macAddress=$(ip link show | grep ether | awk '{print $2}');
sudoCommands=$(grep COMMAND /var/log/sudo/sudo.log | wc -l);

echo "#Architecture: $arch
#CPU physical : $cpu
#vCPU : $vcpu
#Memory Usage: $usedMemory/$totalMemoryMB ($memoryPercentage%)
#Disk Usage: $totalUsedDiskMb/$totalDiskGb ($diskPercentage%)
#CPU Load: $totalCpuLoad%
#Last Boot: $lastBoot
#LVM use: $lvm
#Connexion TCP : $activeTcp ESTABLISHED
#User log: $userLog
#Network; IP $ipAddress ($macAddress)
#Sudo : $sudoCommands cmd"