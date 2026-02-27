#!/bin/bash

source ./common.sh

app_name="catalogue"

check_root

app_setup

Nodejs_setup

System_ctl

Service_file

cp $SCRIPTDIR/mongo.repo /etc/yum.repos.d/mongo.repo

dnf install mongodb-org -y &>>$LOGS_FILE
VALIDATE $? "mongodb-org install"

INDEX=$(mongosh --host $MONGODBIP --quiet --eval 'db.getMongo().getDBNames().indexOf("catalogue")')

if [ $INDEX -ne 0 ]; then
    mongosh --host $MONGODBIP </app/db/master-data.js
else
    echo -e "Product already exist... $Y skipping $N"
fi

Print_total_time