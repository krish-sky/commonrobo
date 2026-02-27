#!/bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"
R="\e[31m" #red
G="\e[32m" #green
Y="\e[33m" #yellow
N="\e[0m" #normal

START_TIME=$(date +%s)


echo "$(date "+%Y-%m-%d %H:%M:%S") | script started executing at $(date)" | tee -a $LOGS_FILE 

CHECKROOT(){ 
if [ $USERID -ne 0 ]; then
    echo "Please run this script with root access"
    exit 1
fi
}

mkdir -p $LOGS_FOLDER

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "$(date "+%Y-%m-%d %H:%M:%S") | $2 ..... is $R Failure $N" | tee $LOGS_FILE
        exit 1
    else
        echo -e "$(date "+%Y-%m-%d %H:%M:%S") | $2 ..... is $G Success $N" | tee $LOGS_FILE
    fi
}

TOTAL_TIME(){
    END_TIME=$(date +%s)
    TOTAL_TIME=$(( $END_TIME - $START_TIME ))
    echo -e "Script executed in $G $TOTAL_TIME in seconds $N"
}