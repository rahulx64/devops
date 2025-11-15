sudo yum install wget unzip httpd -y
mkdir  -p /tmp/webfiles  
# -p help us ignire if directory avaiable 
cd /tmp/webfiles
wget https://www.tooplate.com/zip-templates/2137_softy_pinko.zip
unzip 2137_softy_pinko.zip
sudo cp -r 2137_softy_pinko/* /var/www/html/
# -r  recursive; all files and folders
sudo systemctl start httpd
sudo systemctl enable httpd

rm -rf /tmp/webdfiles

sudo systemctl status httpd 
ls /var/www/html/


skill="Web Server"
echo $skill 

# ---------------------variable-----------------------
package="httpd wget unzip"
svc="httpd"
url="www.xyx.com/p.zip"
art="2090_health"
tempdir="/tmp/webfiles"

# installing dependencies
echo "Installing dependencies..."
sudo yum install -y $package
# creating temp directory
mkdir -p $tempdir

# command line arguments 
echo "Value of 9 is "
echo $0
echo $@  #to acess all arguments

s='thisis rahul ranjani want to become a devops engineer'
# a value in single quitoe is remianed as it is because single quote prevent interpolation

# .in duble quote interpolation happen
echo "value of s is $s"

echo "Today is `date`"
echo "Today is $(date)"



# ls show all files and directories in current working directory but ls -a show archived files also which are hidden files it contain .bashrc 
source .bashrc
# to give permannet variable we can do is export 
vim /etc/profile
ls -a
# | File               | When it Runs                  |
# | ------------------ | ----------------------------- |
# user input
read skills
read -p 'username: ' uservar
read -sp 'password: ' passvar
skills="devops"
if [ $skills == "devops" ]; then
    echo "you are selected"
else
    echo "you are not selected"
fi

#!/bin/bash

LOGFILE="/var/log/sys_monitor.log"

echo "===== System Monitoring Started: $(date) =====" >> $LOGFILE

while true
do
    echo "---- $(date) ----" >> $LOGFILE

    echo "CPU Load:" >> $LOGFILE
    uptime | awk -F'load average:' '{ print $2 }' >> $LOGFILE

    echo -e "\nMemory Usage:" >> $LOGFILE
    free -h >> $LOGFILE

    echo -e "\nDisk Usage:" >> $LOGFILE
    df -h >> $LOGFILE

    echo -e "\n-------------------------------\n" >> $LOGFILE

    sleep 10   # check every 10 seconds
done

#!/bin/bash

###############################################
# All-In-One System Monitoring Script
# CPU, Memory, Disk, Network, Processes, Logs
###############################################

# === CONFIGURATION ===
LOGFILE="/var/log/monitor_all.log"
PROCESS_TO_MONITOR="nginx"
RESTART_ON_FAIL=true
DISK_THRESHOLD=80
MEM_THRESHOLD=80
CPU_THRESHOLD=3.00   # 1-min load average
LOG_TO_WATCH="/var/log/syslog"   # or your app log
KEYWORD="error"       # alert when this keyword appears

###############################################
# FUNCTION: LOGGING
###############################################
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a $LOGFILE
}

###############################################
# CPU CHECK
###############################################
check_cpu() {
    cpu_load=$(awk '{print $1}' /proc/loadavg)
    if (( $(echo "$cpu_load > $CPU_THRESHOLD" | bc -l) )); then
        log "⚠ CPU load high: $cpu_load"
    else
        log "CPU load OK: $cpu_load"
    fi
}

###############################################
# MEMORY CHECK
###############################################
check_memory() {
    mem_used=$(free | awk '/Mem/ {printf("%.0f"), $3/$2 * 100}')
    if [ $mem_used -ge $MEM_THRESHOLD ]; then
        log "⚠ Memory usage high: ${mem_used}%"
    else
        log "Memory OK: ${mem_used}%"
    fi
}

###############################################
# DISK CHECK
###############################################
check_disk() {
    df -H | awk 'NR>1 {print $5 " " $1}' | while read output; do
        usep=$(echo $output | awk '{print $1}' | tr -d '%')
        partition=$(echo $output | awk '{print $2}')

        if [ $usep -ge $DISK_THRESHOLD ]; then
            log "⚠ Disk usage high on $partition: ${usep}%"
        else
            log "Disk OK on $partition: ${usep}%"
        fi
    done
}

###############################################
# NETWORK CHECK
###############################################
check_network() {
    ping -c 1 8.8.8.8 > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        log "Network OK (Internet reachable)"
    else
        log "⚠ Network DOWN – cannot reach Google DNS"
    fi
}

###############################################
# PROCESS CHECK & AUTO RESTART
###############################################
check_process() {
    if pgrep -x "$PROCESS_TO_MONITOR" > /dev/null; then
        log "Process '$PROCESS_TO_MONITOR' is running."
    else
        log "⚠ Process '$PROCESS_TO_MONITOR' NOT running."
        if [ "$RESTART_ON_FAIL" = true ]; then
            log "Attempting to restart $PROCESS_TO_MONITOR..."
            systemctl start $PROCESS_TO_MONITOR
            sleep 2
            if pgrep -x "$PROCESS_TO_MONITOR" > /dev/null; then
                log "Successfully restarted $PROCESS_TO_MONITOR."
            else
                log "❌ Failed to restart $PROCESS_TO_MONITOR."
            fi
        fi
    fi
}

###############################################
# LOG FILE MONITORING (Keyword trigger)
###############################################
check_logs() {
    if grep -qi "$KEYWORD" "$LOG_TO_WATCH"; then
        log "⚠ Keyword '$KEYWORD' detected in log file ($LOG_TO_WATCH)"
    else
        log "Logs OK (no '$KEYWORD' found)"
    fi
}

###############################################
# MAIN LOOP
###############################################
log "====== Starting All-In-One Monitoring ======"

while true; do
    check_cpu
    check_memory
    check_disk
    check_network
    check_process
    check_logs

    log "-------------------------------------------"
    sleep 10   # Adjust interval here
done


# ssh key is best way to login server 