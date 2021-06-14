#!/bin/bash
echo ClusterInstancesScriptStart > /var/log/awsuserdatascript
PRIVATE_IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
CONF=/etc/aerospike/aerospike.conf
sed -i "s/port 3000/port 3000\n\t\taccess-address $PRIVATE_IP virtual\n/g" $CONF


###Point to all instances using the mesh-address config option
sleep 60 # wait for AWS to provision
FILTER=Name=tag-key,Values=StackID
PRIVATEIP=$(aws ec2 describe-instances --filter $FILTER  Name=tag-value,Values=$3 --output=text --region=$1 | grep PRIVATEIPADDRESSES | awk '{print $4}')
echo $PRIVATEIP >> /var/log/awsuserdatascript
sed -i '/.*mesh-seed-address-port/d' $CONF
for i in $PRIVATEIP; do
    sed -i "/interval/i \\\t\tmesh-seed-address-port $i 3002\n" $CONF
done

# Check if namespace file in input
CODE=$(curl -Is $4 | head -n 1 | cut -d$' ' -f2)
if [ "$CODE" != "200" ]; then echo 'Namespace File not found' >> /var/log/awsuserdatascript
else sed -i '/namespace test/,$d' $CONF
curl -s $4 >> $CONF; fi
systemctl restart aerospike

echo OtherInstancesScriptFinish >> /var/log/awsuserdatascript
(crontab -l 2>/dev/null; echo '*/5 * * * * /opt/aerospike/poll_sqs') | crontab -
if [[ "$2" == "yes" ]]; then
(crontab -l 2>/dev/null; echo '*/5 * * * * /opt/aerospike/cloudwatch') | crontab -
fi