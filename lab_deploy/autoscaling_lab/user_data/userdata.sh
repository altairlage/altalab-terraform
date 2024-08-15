#!/bin/bash
# Update and install python3
sudo yum update -y
sudo yum install -y python3 python3-pip git

#Export environment variables
export APP_NAME=site

#Declare files and create directory
EC2_FILES="lab app.py requirements.txt templates/index.html"
mkdir /home/ec2-user/$APP_NAME

# #Copy files from S3
# for file_ in $EC2_FILES
# do
# aws s3 cp s3://$PROVISION_BUCKET_NAME/$LAB_ID/$APP_NAME/$file_ /home/ec2-user/$APP_NAME/$file_
# done

# Checkout repo and copy files to final destination
git clone https://github.com/altairlage/ansible-semaphore-lab.git /home/ec2-user/lab
cp -rf /home/ec2-user/lab/autoscaling_lab/app/* /home/ec2-user/site
cp -rf /home/ec2-user/lab/autoscaling_lab/app/templates/index.html /home/ec2-user/site
mv /home/ec2-user/lab/app/site /etc/rc.d/init.d/
chmod +x /etc/rc.d/init.d/site
sudo chown -R ec2-user:ec2-user /home/ec2-user/$APP_NAME

# Install requirements
sudo pip3 install -r /home/ec2-user/$APP_NAME/requirements.txt

# Install and start app
chkconfig site on
service site start