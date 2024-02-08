#! /bin/bash
sudo yum update -y
# Install nmap
sudo yum install -y nmap
# Install the agent on the EC2 instance, which does create the cwagent account
sudo yum install amazon-cloudwatch-agent -y
#Create CW Agent Config File
cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json << EOF
{
  "agent": {
    "metrics_collection_interval": 10
  },
  "metrics": {
    "metrics_collected": {
      "disk": {
        "resources": ["/", "/tmp"],
        "measurement": ["disk_used_percent"],
        "ignore_file_system_types": ["sysfs", "devtmpfs"]
      },
      "mem": {
        "measurement": ["mem_available_percent"]
      }
    },
    "aggregation_dimensions": [["InstanceId", "InstanceType"], ["InstanceId"]]
  }
}
EOF
# Start CloudWatchAgent and systemctl enable CW Agent
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
sudo systemctl enable amazon-cloudwatch-agent

echo "Cloud-Init executed User Data script" | tee /tmp/UserData.status
#sudo systemctl enable httpd
#sudo service httpd start  
#echo "<h1>Successful Infra Deployment of: $(hostname -s) AWS Infra created using Terraform </h1>" | sudo tee /var/www/html/index.html