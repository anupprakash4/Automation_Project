#!/bin/bash

s3_bucket="upgrad-anoop"
name=anoop

set -eu -o pipefail # fail on error , debug all lines
sudo -n true
test $? -eq 0 || exit 1 "You should have Sudo Privilege to run this Script"
echo "Package Updates"
sudo apt-get update -y
if [ $(dpkg-query -W -f='${Status}' apache2 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
<<<<<<< HEAD
    sudo apt install -y apache2
else 
    echo "Package already installed"	  
=======
       sudo apt install -y apache2
else 
       echo "Package already installed"	  
>>>>>>> Dev
fi
  
package_check_awscli=`apt -qq list awscli --installed |wc -l`

  if [ $package_check_awscli == 0 ]
  then
       apt-get install awscli -y
  else
       echo "AWS CLI installed already"  
  fi

#check Apache running status 
if pgrep -x "apache2" >/dev/null
then 
   echo "apache2 is running"
else
   service apache2 start
fi  

#check apache enabled or not
apache_check=`systemctl status apache2.service  | grep Active | awk '{ print $3 }'`

if [ $apache_check == "(dead)" ]
then
    systemctl enable apache2.service
fi

timestamp="$(date '+%d%m%Y-%H%M%S')"
filename="/tmp/${myname}-httpd-logs-${timestamp}.tar"

#create tar file
tar -cvf ${filename} $( find /var/log/apache2/ -name "*.log")

filesize=$(du -sh $filename | awk '{print $1}')

#Copying to AWS S3 bucket

aws s3 cp ${filename} s3://${s3_bucket}/${filename}

#Task 3 - To keep logs in inventory.html
	if [ -e /var/www/html/inventory.html ]
	then
	    echo "httpd-logs &nbsp;&nbsp;&nbsp; ${timestamp} &nbsp;&nbsp;&nbsp; tar &nbsp;&nbsp;&nbsp; $filesize " >> /var/www/html/inventory.html
	else
	    echo "Log Type &nbsp;&nbsp;&nbsp;  Date Created &nbsp;&nbsp;&nbsp; Type &nbsp;&nbsp;&nbsp;  Size<br>" >> /var/www/html/inventory.html
	    echo "httpd-logs &nbsp;&nbsp;&nbsp; ${timestamp} &nbsp;&nbsp;&nbsp; tar &nbsp;&nbsp;&nbsp; $filesize" >> /var/www/html/inventory.html
	fi

# check cron file is exist of not, if it is doesn't exist then create it
# Note:- script will execute once in day at 4.05AM
if  [ ! -f  /etc/cron.d/automation ]
then
   echo "5 4 * * * root /root/Automation_Project/automation.sh" > /etc/cron.d/automation
fi
