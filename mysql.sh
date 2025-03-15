#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPTNAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPTNAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
N="\e[0m"

VALIDATE(){
if [ $1 -ne 0 ]
then 
    echo -e "$2 is $R Failure $N"
    exit 1
else
    echo -e "$2 is $G sucess $N"
    fi
}

if [ $USERID -ne 0 ]
then 
    echo "Please run with root user"
    exit 1
else
    echo "You are a root user"
fi

dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "installing Mysql server"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "Enabling Mysql server"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "stating mysql server"
