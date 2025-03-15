#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPTNAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPTNAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
echo "Pleae enter DB password"
read -s Mysql_root_password

VALIDATE(){
if [ $1 -ne 0 ]
then 
    echo -e "$2 is $R Failure $N"
    exit 1
else
    echo -e "$2 is $G success $N"
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
VALIDATE $? "starting mysql server"

# mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
# VALIDATE $? "Setting up root password"


#Below code will be useful for idempotent nature
mysql -h db.swetha.store -uroot -p${Mysql_root_password} -e 'show databases;' &>>$LOGFILE
if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ${Mysql_root_password} &>>$LOGFILE
    VALIDATE $? "MySQL Root password Setup"
else
    echo -e "MySQL Root password is already setup...$Y SKIPPING $N"
fi
