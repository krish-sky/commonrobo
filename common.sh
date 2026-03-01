#!/bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"
R="\e[31m" #red
G="\e[32m" #green
Y="\e[33m" #yellow
N="\e[0m" #normal


SCRIPTDIR=$PWD
MONGODBIP="mongodb.krishsky.online"

Start_time=$(date +%s)

mkdir -p $LOGS_FOLDER

echo "$(date "+%Y-%m-%d %H:%M:%S") | Script started executing at: $(date)" | tee -a $LOGS_FILE


check_root(){
if [ $USERID -ne 0 ]; then
    echo "Please run this script with root access"
    exit 1
fi
}

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "$(date "+%Y-%m-%d %H:%M:%S") | $2 ..... is $R Failure $N" | tee $LOGS_FILE
        exit 1
    else
        echo -e "$(date "+%Y-%m-%d %H:%M:%S") | $2 ..... is $G Success $N" | tee $LOGS_FILE
    fi
}


Nodejs_setup(){

    dnf module disable nodejs -y &>>$LOGS_FILE
    VALIDATE $? "Disable Nodejs"

    dnf module enable nodejs:20 -y &>>$LOGS_FILE
    VALIDATE $? "enable Nodejs"

    dnf install nodejs -y &>>$LOGS_FILE
    VALIDATE $? "install Nodejs"  

    npm install  &>>$LOGS_FILE
    VALIDATE $? "npm install"  
}

Java_setup(){

    dnf install maven -y &>>$LOGS_FILE
    VALIDATE $? "Installing maven"
    
    cd /app 
    mvn clean package  &>>$LOGS_FILE
    VALIDATE $? "package installation"

    mv target/shipping-1.0.jar shipping.jar &>>$LOGS_FILE
    VALIDATE $? "shipping jar"


}

    app_setup(){
            id roboshop  &>>$LOGS_FILE

        if [ $? -ne 0 ]; then   
            useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
            VALIDATE $? "System User created"
        else
            echo -e "Roboshop user already exist ... $Y SKIPPING $N"
       fi

        mkdir -p /app 
        VALIDATE $? "app created"

        curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip 
        VALIDATE $? "$app_name download"

        cd /app 
        VALIDATE $? "Moving to app directory"

        rm -rf /app/*
        VALIDATE $? "removing existing code"

        unzip /tmp/$app_name.zip
        VALIDATE $? "Unzip code"

    }

    
    Service_file(){
    cp $SCRIPTDIR/$app_name.service /etc/systemd/system/$app_name.service
    VALIDATE $? "Copying $app_name.service file"
    }

    System_ctl(){
    systemctl daemon-reload
    systemctl enable $app_name
    systemctl start $app_name
    VALIDATE $? "reload enable Start $app_name"
    }

    Restart_app(){
        systemctl restart $app_name
        VALIDATE $? "Restarting $app_name"
    }

Print_total_time(){
End_time=$(date +%s)
Total_time=$(( $End_time - $Start_time ))
echo -e "$(date "+%Y-%m-%d %H:%M:%S") | Script execute in: $G $Total_time seconds $N" | tee -a $LOGS_FILE
}
