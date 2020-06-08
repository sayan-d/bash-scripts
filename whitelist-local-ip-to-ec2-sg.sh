#!/bin/bash
# Script to Whitelist your local public IP Address in an EC2 security group (replace your old whitelisted IP as well)

SG_ID="" #Add the security group id here
PORT_ID="443"

OLD_IP_PATH="/opt/myscripts"
if [ -z $OLD_IP_PATH ];then
  mkdir -p $OLD_IP_PATH
  touch $OLD_IP_PATH/MyOldLocalIP
fi

# Get current local public IP address
LOCAL_IP=`curl -q ifconfig.me`

# Get the old IP address
OLD_LOCAL_IP=`cat $OLD_IP_PATH/MyOldLocalIP`


# Del ingress rule
`aws ec2 revoke-security-group-ingress --group-id $SG_ID --protocol tcp --port $PORT_ID --cidr $OLD_LOCAL_IP/32`


# Add ingress rule
`aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port $PORT_ID --cidr $LOCAL_IP/32`

# Write the value of current IP to the old ip file
echo $LOCAL_IP > $OLD_IP_PATH/MyOldLocalIP
