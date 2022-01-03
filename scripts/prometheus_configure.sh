#!/bin/bash

echo "[DEBUG] updating prometheus.yml"
PROMETHUS_CONFIG_LOCATION=/home/ec2-user/monitoring_stack/prometheus-2.30.3.linux-amd64/prometheus.yml
sleep 60 # wait for instance to come up
aerospike_instance_private_ip=$(aws --output text --query "Reservations[*].Instances[*].PrivateIpAddress" ec2 describe-instances --region "${AWS_REGION}" --instance-ids `aws --output text --query "AutoScalingGroups[0].Instances[*].InstanceId" autoscaling describe-auto-scaling-groups --auto-scaling-group-names "AerospikeCluster" --region "${AWS_REGION}"`)

ips=""
for i in ${aerospike_instance_private_ip[@]}
do
    ips+=\'${i}:9145\',
done
ips=${ips%?}
prometheus_target=`echo [$ips]`

# replace aerospike_targets
sed -i "s/aerospike_targets/${prometheus_target}/g" ${PROMETHUS_CONFIG_LOCATION} 

# start prometheus
sudo /home/ec2-user/monitoring_stack/prometheus-2.30.3.linux-amd64/prometheus --config.file=/home/ec2-user/monitoring_stack/prometheus-2.30.3.linux-amd64/prometheus.yml > /dev/null 2>&1 &