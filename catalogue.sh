#!/bin/bash

source ./common.sh

app_name="catalogue"

check_root

app_setup

Nodejs_setup

Service_file

System_ctl

cp $SCRIPTDIR/mongo.repo /etc/yum.repos.d/mongo.repo  &>>$LOGS_FILE

dnf install mongodb-org -y &>>$LOGS_FILE
VALIDATE $? "mongodb-org install"

INDEX=$(mongosh --host $MONGODBIP --quiet --eval 'db.getMongo().getDBNames().indexOf("catalogue")') &>>$LOGS_FILE

if [ $INDEX -ne 0 ]; then
    mongosh --host $MONGODBIP </app/db/master-data.js &>>$LOGS_FILE
else
    echo -e "Product already exist... $Y skipping $N"
fi

Print_total_time | tee &>>$LOGS_FILE