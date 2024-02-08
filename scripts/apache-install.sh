#! /bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl enable httpd
sudo service httpd start  
echo "<h1>Successful Infra Deployment of: $(hostname -s) AWS Infra created using Terraform </h1>" | sudo tee /var/www/html/index.html
echo "Cloud-Init executed User Data script" | tee /tmp/UserData.status