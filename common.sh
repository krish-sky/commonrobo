#!/bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"
R="\e[31m" #red
G="\e[32m" #green
Y="\e[33m" #yellow
N="\e[0m" #normal

Start_time=$(date +%s)

mkdir -p $LOGS_FOLDER

echo "$(date "+%Y-%m-%d %H:%M:%S") | Script started executing at: $(date)" | tee -a $LOGS_FILE


check_root(){
if [ $USERID -ne 0 ]; then
    echo "Please run this script with root access"
    exit 1
fi
}

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "$(date "+%Y-%m-%d %H:%M:%S") | $2 ..... is $R Failure $N" | tee $LOGS_FILE
        exit 1
    else
        echo -e "$(date "+%Y-%m-%d %H:%M:%S") | $2 ..... is $G Success $N" | tee $LOGS_FILE
    fi
}

Print_total_time(){
End_time=$(date +%s)
Total_time=$(( $End_time - $Start_time ))
echo -e "$(date "+%Y-%m-%d %H:%M:%S") | Script execute in: $G $Total_time seconds $N" | tee -a $LOGS_FILE
}
