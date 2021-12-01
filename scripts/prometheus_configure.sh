#!/bin/bash
set -x
chmod +x /var/tmp/awsuserdatascript
echo update_prometheus_config.sh > /var/tmp/awsuserdatascript
yum install -y jq
PROMETHUS_CONFIG_LOCATION=/home/ec2-user/monitoring_stack/prometheus-2.30.3.linux-amd64/prometheus.yml
# get aerospike IPs
aerospike_instance_private_ip=$(aws --output text --query "Reservations[*].Instances[*].PrivateIpAddress" ec2 describe-instances --instance-ids `aws --output text --query "AutoScalingGroups[0].Instances[*].InstanceId" autoscaling describe-auto-scaling-groups --auto-scaling-group-names "AerospikeCluster" --region "${AWS_REGION}"`)
echo $aerospike_instance_private_ip >> /var/tmp/awsuserdatascript
echo $AWS_REGION
echo $(aws --version) >> /var/tmp/awsuserdatascript

# append :9145 port in all IPS and form prometheus target
ips=""
for i in ${aerospike_instance_private_ip[@]}
do
    ips+=\'${i}:9145\',
done
ips=${ips%?}

prometheus_target=`echo [$ips]`

# replace aerospike_targets
sed -e "s/aerospike_targets/$prometheus_target/g" $PROMETHUS_CONFIG_LOCATION