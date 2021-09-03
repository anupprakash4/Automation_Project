#!/bin/bash
s3_bucket="upgrad-anoop"
name=anoop
timestamp="$(date '+%d%m%Y-%H%M%S')"
filename="/tmp/${myname}-httpd-logs-${timestamp}.tar"

set -eu -o pipefail # fail on error , debug all lines
sudo -n true
test $? -eq 0 || exit 1 "You should have Sudo Privilege to run this Script"
echo "Package Updates"
sudo apt-get update -y
if [ $(dpkg-query -W -f='${Status}' apache2 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
    sudo apt install -y apache2
else 
    echo "Package already installed"	  
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

#create tar file
tar -cvf ${filename} $( find /var/log/apache2/ -name "*.log")

filesize=$(du -sh $filename | awk '{print $1}')

#Copying to AWS S3 bucket

aws s3 cp ${filename} s3://${s3_bucket}/${filename}

