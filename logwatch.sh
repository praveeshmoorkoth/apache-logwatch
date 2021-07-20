#!/bin/bash

# This script scan for number of HTTP 4xx & 5xx response statuses in the given apache log file. 
# Script check for accumalted number of errors for past 1hr and send an email if it reaches beyond the threshold.

# Declare Variables
THRESHOLD=100 # Integer value
EMAIL_LIST="praveeshgm@gmail.com,praveeshtestgm@gmail.com" # comma seperate list of email IDs
INTERVAL=1 #Duration of log watch in hours

# EMAIL Server configurations, Update the details if necessary 
SMTP_S="smtp=smtps://smtp.gmail.com:465"
#USER="praveeshtestgm@gmail.com"
#PASSWORD="xxxxxxxxxxx"

# function usage
usage() 
{ 
        printf "\nUsage:  sh `basename $0` <apache_log_file>\n"
        printf "Notes:\n"
        printf "        param1 : Full path of the apache log file\n"
        exit 1
}

# function watch_log
log_watch()
{
        from_h=`date --date="$INTERVAL hours ago" '+%H:'`
        from_d=`date --date="$INTERVAL hours ago" '+%d/%b/%Y:'`
        fourx_count=`grep -e $from_d$from_h $LOG_FILE | grep "HTTP/1.1\" 4[0-9][0-9]" | wc -l`
        fivex_count=`grep -e $from_d$from_h $LOG_FILE | grep "HTTP/1.1\" 5[0-9][0-9]" | wc -l`
        t_error_count=`expr $fourx_count + $fivex_count`
        if [ $t_error_count -ge $THRESHOLD ]; then
                notify
        fi
}

# function for mail notification
notify()
{
        body="Total number of 4xx and 5xx response code for last 1hour is exceeded the default threshold($THRESHOLD).\n\nTotal No.of 4xx errors: $fourx_count\n Total No.of 5xx errors: $fivex_count\n\nPlease take necessary actions and do not reply to this email"
       echo -e $body | mailx -v -s "Critical Notification of Apache Access Logs" -S $SMTP_S -S smtp-auth=login -S from="No-Reply <no-reply@moxtra.com>" $EMAIL_LIST
}

# Main
        if [ "$#" -lt 1 ]; then
                printf "\nERROR: Insufficient Arguments"
                usage
        elif ! [ -f "$1" ]; then
                printf "\nERROR: Apache log file does not exists"
                usage
        fi
        LOG_FILE=$1
        log_watch
