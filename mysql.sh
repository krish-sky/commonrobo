#!/bin/bash

source ./common.sh

check_root

app_name="mysql"

dnf install mysql-server -y
VALIDATE $? "Installing Mysql"


mysql_secure_installation --set-root-pass RoboShop@1
VALIDATE $? "Password setup"

Print_total_time