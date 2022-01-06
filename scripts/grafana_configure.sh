#!/bin/bash

# Adding grafana dashboard in monitoring bastion host. Ref : https://docs.aerospike.com/docs/tools/monitorstack/configure/configure-grafana.html
echo "[DEBUG] adding aerospike grafana dashboard"

sed -i 's/;provisioning/provisioning/' /etc/grafana/grafana.ini
sed -i "s,conf/provisioning,/etc/grafana/provisioning," /etc/grafana/grafana.ini
sed -i "s,;http_port,http_port," /etc/grafana/grafana.ini
sed -i "s,3000,3100," /etc/grafana/grafana.ini
chmod 664 /etc/grafana/grafana.ini
grafana-cli plugins install camptocamp-prometheus-alertmanager-datasource
mkdir -p /etc/grafana/provisioning/datasources /etc/grafana/provisioning/dashboards /var/lib/grafana/dashboards
wget https://raw.githubusercontent.com/aerospike/aerospike-monitoring/master/config/grafana/provisioning/datasources/all.yaml -P /etc/grafana/provisioning/datasources/
PUBLIC_IP=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)
sed -i "s,http://alertmanager,http://$PUBLIC_IP," /etc/grafana/provisioning/datasources/all.yaml
sed -i "s,http://prometheus,http://$PUBLIC_IP," /etc/grafana/provisioning/datasources/all.yaml
wget https://raw.githubusercontent.com/aerospike/aerospike-monitoring/master/config/grafana/dashboards/alerts.json -P /var/lib/grafana/dashboards/
wget https://raw.githubusercontent.com/aerospike/aerospike-monitoring/master/config/grafana/dashboards/cluster.json -P /var/lib/grafana/dashboards/
wget https://raw.githubusercontent.com/aerospike/aerospike-monitoring/master/config/grafana/dashboards/exporters.json -P /var/lib/grafana/dashboards/
wget https://raw.githubusercontent.com/aerospike/aerospike-monitoring/master/config/grafana/dashboards/latenct.json -P /var/lib/grafana/dashboards/
wget https://raw.githubusercontent.com/aerospike/aerospike-monitoring/master/config/grafana/dashboards/namespace.json -P /var/lib/grafana/dashboards/
wget https://raw.githubusercontent.com/aerospike/aerospike-monitoring/master/config/grafana/dashboards/node.json -P /var/lib/grafana/dashboards/
wget https://raw.githubusercontent.com/aerospike/aerospike-monitoring/master/config/grafana/dashboards/users.json -P /var/lib/grafana/dashboards/
wget https://raw.githubusercontent.com/aerospike/aerospike-monitoring/master/config/grafana/dashboards/xdr.json -P /var/lib/grafana/dashboards/
wget https://raw.githubusercontent.com/aerospike/aerospike-monitoring/master/config/grafana/provisioning/dashboards/all.yaml -P /etc/grafana/provisioning/dashboards/
systemctl restart grafana-server
