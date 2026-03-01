#!/bin/bash

source ./common.sh

app_name="shipping"

check_root

app_setup

Java_setup

Service_file
System_ctl

dnf install mysql -y &>>$LOGS_FILE
VALIDATE $? "install mysql"

mysql -h $MYSQL_HOST -uroot -pRoboShop@1 -e 'use cities'

if [ $? -ne 0 ]; then
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/schema.sql
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/app-user.sql 
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/master-data.sql
else  
    echo -e "Database already exist....$Y SKIPPING $N"
fi

systemctl restart shipping
VALIDATE $? "Shipping Restart"

Print_total_time