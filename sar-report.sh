#!/bin/sh
#Sar / Systat must be installed and have enough data
#In this case, the script is build for full month summary
# RnD - Willy Robertus Leonardo


#Declare Misc Variables
hostname=`uname -a | awk {'print $2'}`
konversiGB="1048576" #Untuk konversi dari KB ke GB 1024 kuadrat

##CPU
printf "\n \n \n"
echo "+------------------------------------CPU INFORMATION--------------------------------"
echo "+----------------------------------------------------------------------------------+"
echo "|Average:         CPU     %user     %nice   %system   %iowait    %steal     %idle  |"
echo "+----------------------------------------------------------------------------------+"

userArr=()
niceArr=()
systemArr=()
iowaitArr=()
stealArr=()
count=0


for file in `ls -tr /var/log/sa/sa* | grep -v sar`

do

count=$((count+1))
datCpu=`sar -f $file | head -n 1 | awk '{print $4}'`

echo -n $datCpu
sar -f $file  | grep -i Average | sed "s/Average://"
userArr+=(`sar -f $file  | grep -i Average | sed "s/Average://" | awk -F ' ' '{print $2}'`)
niceArr+=(`sar -f $file  | grep -i Average | sed "s/Average://" | awk -F ' ' '{print $3}'`)
systemArr+=(`sar -f $file  | grep -i Average | sed "s/Average://" | awk -F ' ' '{print $4}'`)
iowaitArr+=(`sar -f $file  | grep -i Average | sed "s/Average://" | awk -F ' ' '{print $5}'`)
stealArr+=(`sar -f $file  | grep -i Average | sed "s/Average://" | awk -F ' ' '{print $6}'`)
idleArr+=(`sar -f $file  | grep -i Average | sed "s/Average://" | awk -F ' ' '{print $7}'`)

done

##Memory
printf "\n \n \n"
echo "+----------------------------------MEMORY INFORMATION------------------------------------------------------------+"
echo "+----------------------------------------------------------------------------------------------------------------+"
echo "|Average:     kbmemfree kbmemused  %memused kbbuffers  kbcached  kbcommit   %commit  kbactive   kbinact   kbdirty|"
echo "+----------------------------------------------------------------------------------------------------------------+"



memfreeArr=()
memusedArr=()
memusedpArr=()
buffersArr=()
cachedrArr=()
commitArr=()
commitpArr=()
activeArr=()
inactArr+=()
dirtyArr+=()

for file in `ls -tr /var/log/sa/sa* | grep -v sar`

do

datMemory=`sar -f $file | head -n 1 | awk '{print $4}'`
echo -n $datMemory
sar -r -f $file  | grep -i Average | sed "s/Average://"
memfreeArr+=(`sar -r -f $file  | grep -i Average | sed "s/Average://" | awk -F ' ' '{print $1}'`)
memusedArr+=(`sar -r -f $file  | grep -i Average | sed "s/Average://" | awk -F ' ' '{print $2}'`)
memusedpArr+=(`sar -r -f $file  | grep -i Average | sed "s/Average://" | awk -F ' ' '{print $3}'`)
buffersArr+=(`sar -r -f $file  | grep -i Average | sed "s/Average://" | awk -F ' ' '{print $4}'`)
cachedArr+=(`sar -r -f $file  | grep -i Average | sed "s/Average://" | awk -F ' ' '{print $5}'`)
commitArr+=(`sar -r -f $file  | grep -i Average | sed "s/Average://" | awk -F ' ' '{print $6}'`)
commitpArr+=(`sar -r -f $file  | grep -i Average | sed "s/Average://" | awk -F ' ' '{print $7}'`)
activeArr+=(`sar -r -f $file  | grep -i Average | sed "s/Average://" | awk -F ' ' '{print $8}'`)
inactArr+=(`sar -r -f $file  | grep -i Average | sed "s/Average://" | awk -F ' ' '{print $9}'`)
dirtyArr+=(`sar -r -f $file  | grep -i Average | sed "s/Average://" | awk -F ' ' '{print $10}'`)

done


#Operasi perhitungan
echo "+----------------------------------------------------------------------------------+"
printf "\n \n \n"
echo "+----------------------------------Results------------------------------------------------------------+"

echo "Server Hostname : " $hostname
printf "\n \n"


#CPU Section
sumUser=$( IFS="+"; bc <<< "${userArr[*]}" )
sumNice=$( IFS="+"; bc <<< "${niceArr[*]}" )
sumSystem=$( IFS="+"; bc <<< "${systemArr[*]}" )
sumIowait=$( IFS="+"; bc <<< "${iowaitArr[*]}" )
sumSteal=$( IFS="+"; bc <<< "${stealArr[*]}" )
sumIdle=$( IFS="+"; bc <<< "${idleArr[*]}" )


avgUser=`echo "scale=2; $sumUser/$count" | bc`
avgNice=`echo "scale=2; $sumNice/$count" | bc`
avgSystem=`echo "scale=2; $sumSystem/$count" | bc`
avgIowait=`echo "scale=2; $sumIowait/$count" | bc`
avgSteal=`echo "scale=2; $sumSteal/$count" | bc`
avgIdle=`echo "scale=2; $sumIdle/$count" | bc`

#Memory Section
sumFreem=$( IFS="+"; bc <<< "${memfreeArr[*]}" )
sumbuffer=$( IFS="+"; bc <<< "${buffersArr[*]}" )
sumcached=$( IFS="+"; bc <<< "${cachedArr[*]}" )


totalfreem=$(expr $sumFreem + $sumbuffer + $sumcached)
avgfreem=`echo "scale=2; $totalfreem/$count" | bc`

avgfreem=`echo "scale=2; $avgfreem/$konversiGB" | bc`

#Output printing
printf "\n \n \n"

echo "Total Sample Data = " $count " Hari"
echo "CPU Results : "
echo "Average Monthly %user : " $avgUser
echo "Average Monthly %Nice : " $avgNice
echo "Average Monthly %System : " $avgSystem
echo "Average Monthly %IOWait : " $avgIowait
echo "Average Monthly %Steal : " $avgSteal
echo "Average Monthly %Idle : " $avgIdle 
printf "\n \n \n"

echo "Memory Results :"
echo "Free Memory Average   : " $avgfreem "GB / Day" 

printf "\n \n \n"
printf "Informasi disk : \n"
df -h 
printf "\n \n \n"