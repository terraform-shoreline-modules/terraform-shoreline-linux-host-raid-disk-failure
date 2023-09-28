
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Host RAID Disk Failure
---

Host RAID Disk Failure is an incident type that occurs when at least one device in a RAID array fails. This can result in a loss of data or service interruption. The incident requires attention and possibly a disk swap to restore the RAID array and prevent further failures.

### Parameters
```shell
export RAID_DEVICE="PLACEHOLDER"

export DISK_DEVICE="PLACEHOLDER"

export NEW_DISK="PLACEHOLDER"

export FAILED_DISK="PLACEHOLDER"

export BACKUP_FILE="PLACEHOLDER"

export NUMBER_OF_DISKS="PLACEHOLDER"
```

## Debug

### Check if the system recognizes the RAID array
```shell
cat /proc/mdstat
```

### Check the disks status in the RAID array
```shell
mdadm --detail /dev/md${RAID_DEVICE}
```

### Check the SMART status of all disks in the RAID array
```shell
smartctl -a /dev/${DISK_DEVICE}
```

### Check the logs for disk errors
```shell
dmesg | grep -i "hard error"
```

### Check the system logs for disk errors
```shell
grep -i "I/O error" /var/log/messages
```

### Check the RAID events log
```shell
cat /var/log/messages | grep -i "mdadm"
```

### Check the disk health using S.M.A.R.T
```shell
smartctl -H /dev/${DISK_DEVICE}
```

### Check the filesystem consistency on the RAID array
```shell
fsck /dev/md${RAID_DEVICE}
```

### Check the RAID array integrity and rebuild status
```shell
mdadm --detail /dev/md${RAID_DEVICE}
```

### Check the partitions on the RAID array
```shell
lsblk
```

## Repair

### Replace the failed disk in the RAID array and rebuild the array.
```shell


#!/bin/bash



# Replace the failed disk in the RAID array

echo "Please replace the failed disk with a new one."

echo "Once you have replaced the disk, press Enter to continue."

read



# Rebuild the RAID array

echo "Rebuilding the RAID array..."

mdadm --manage /dev/md0 --remove /dev/${FAILED_DISK}

mdadm --manage /dev/md0 --add /dev/${NEW_DISK}

mdadm --grow /dev/md0 --raid-devices=${NUMBER_OF_DISKS} --backup-file=/root/${BACKUP_FILE}

echo "RAID array successfully rebuilt."


```