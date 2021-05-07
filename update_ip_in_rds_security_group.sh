#!/bin/bash
# script to update specific ip address in rds security group
typeset -A config

while read line
do
	if echo $line | grep -F = &>/dev/null
	then
		varname=$(echo "$line" | cut -d '=' -f 1)
		config[$varname]=$(echo "$line" | cut -d '=' -f 2-)
	fi
done < ip.conf

echo "AWS account ID: ${config[profile]}"
echo "security group: ${config[group]}"
echo "will add ${config[ip]}"
echo "access port ${config[port]}"
echo ${config[description]}
sleep 5
echo "start to add..."

aws --profile ${config[profile]} ec2 authorize-security-group-ingress --group-id ${config[group]} --ip-permissions IpProtocol=tcp,FromPort=${config[port]},ToPort=${config[port]},IpRanges=["{CidrIp=${config[ip]}/32,Description=""${config[description]}""}"]
