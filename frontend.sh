#!/bin/bash

source ./common.sh

app_name="frontend"

check_root


dnf module disable nginx -y &>>$LOGS_FILE
VALIDATE $? "Disable Nginx"

dnf module enable nginx:1.24 -y &>>$LOGS_FILE
VALIDATE $? "Enable Nginx"

dnf install nginx -y &>>$LOGS_FILE
VALIDATE $? "Installed Nginx"

systemctl enable nginx  &>>$LOGS_FILE
systemctl start nginx 
VALIDATE $? "start and enabled Nginx"


mkdir -p /app 
VALIDATE $? "app created"

rm -rf /usr/share/nginx/html/* 
VALIDATE $? "Removing code"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip 
VALIDATE $? "frontend download"

cd /usr/share/nginx/html  
VALIDATE $? "Moving to HTML directory"

unzip /tmp/frontend.zip
VALIDATE $? "Unzip code"

rm -rf /etc/nginx/nginx.conf
VALIDATE $? "removing old conf"

cp $SCRIPTDIR/nginx.conf /etc/nginx/nginx.conf
VALIDATE $? "Copied our nginx conf file"

systemctl restart nginx 
VALIDATE $? "Restarted Nginx"

Print_total_time