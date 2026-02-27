#!/bin/bash

source ./common.sh 

check_root

cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE "$?" "copying mongo.repo"

dnf install mongodb-org -y   &>>$LOGS_FILE
VALIDATE "$?" "Mongodb installed"

systemctl enable mongod &>>$LOGS_FILE
VALIDATE "$?" "systemctl enable mongodb"


systemctl start mongod &>>$LOGS_FILE
VALIDATE "$?" "systemctl start mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "Allowing remote connections"

systemctl restart mongod &>>$LOGS_FILE
VALIDATE $? "systemctl restart mongodb"

echo "running scrpit from common"