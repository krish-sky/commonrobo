#!/bin/bash

source ./common.sh

check_root

app_name="mysqld"

dnf install mysql-server -y
VALIDATE $? "Installing Mysql"


mysql_secure_installation --set-root-pass RoboShop@1
VALIDATE $? "Password setup"

systemctl enable $app_name
systemctl start $app_name

Print_total_time
