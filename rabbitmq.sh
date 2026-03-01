#!/bin/bash

source ./common.sh

app_name="rabbitmq-server"

check_root

dnf install rabbitmq-server -y &>>$LOGS_FILE
VALIDATE $? "Rabbitmq server"

System_ctl

rabbitmqctl list_users | grep -q "^roboshop\b" &>>$LOGS_FILE

if [ $? -ne 0 ]; then
    rabbitmqctl add_user roboshop roboshop123
else 
    echo "already user exist .... $Y SKIPPING $N"
fi

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOGS_FILE
VALIDATE $? "Permission set"

Print_total_time