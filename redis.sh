#!/bin/bash

source ./common.sh

check_root

dnf module disable redis -y &>>$LOGS_FILE
VALIDATE $? "Disable redis"

dnf module enable redis:7 -y &>>$LOGS_FILE
VALIDATE $? "Enable redis"


dnf install redis -y &>>$LOGS_FILE
VALIDATE $?  "Install redis"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf


VALIDATE $? "Allowing remote connections"