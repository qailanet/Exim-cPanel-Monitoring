#!/bin/bash

echo "IDCloudHost Exim Plugins Installer"
echo "Get Nixstats Plugins Folder.. "
nxplugindir=$(nixstatsagent --info | awk 'NR == 3 {print $3}')
echo "Nixstats plugins folder Results : $nxplugindir"
echo "Clear Old plugins file"
rm -rf $nxplugindir/idch-exim.py
echo "Success.."
echo "Add nixstatsagent to sudoers"
echo -e "\nnixstats ALL=(ALL) NOPASSWD: /usr/sbin/exim" >> /etc/sudoers
echo "Downloading Nixstats Custom Plugins from git repository"
wget https://github.com/mekbuk/Exim-cPanel-Monitoring/blob/master/idch-exim.py -O $nxplugindir/idch-exim.py
echo "Append Config to /etc/nixstats.ini in .. 3  "
echo "Append Config to /etc/nixstats.ini in .. 2  "
echo "Append Config to /etc/nixstats.ini in .. 1  "
if grep -R "idch-exim" /etc/nixstats.ini 
then
	echo "idch-exim Exists in nixstats config.. skipping enable idch-exim"
else
	echo -e "\n[idch-exim]\nenabled = yes" >> /etc/nixstats.ini
fi
echo "Done.. New /etc/nixstats.ini showing ..."
cat /etc/nixstats.ini
echo -e "\n \n \n \n "
echo "Testing Plugin.. Output showing ..."
nixstatsagent test idch-exim
echo "All Setup Done .. Restarting nixstats agent ..."
service nixstatsagent restart
echo "Complete.. Script terminating ..."
