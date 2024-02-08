#main

resource "aws_vpc" "algvpc" {
  #https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc.html
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  tags = {
    Name    = "AL VPC"
    Project = var.project
  }
}

resource "aws_ec2_serial_console_access" "infra_tty" {
  enabled = true
}

# ========================= Start Data ================================= # 
data "aws_availability_zones" "all_zones" {}

data "aws_route_table" "main" {
  #https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_table
  #Getting the route table ID of the main route table
  vpc_id = aws_vpc.algvpc.id
  filter {
    name   = "association.main"
    values = ["true"]
  }
}

/*
data "aws_instances" "autos_instances" {
  #https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/instances

  filter {
    name   = "tag:Project"
    values = ["${var.project}"]
    #values = [var.project]
  }
  depends_on = [aws_autoscaling_group.autos_grp01] #Note: Without the depend_on this was failing because it finds no instances
}
*/

# ========================= End Data ================================= # 

resource "aws_subnet" "pvt_subnets" {
  #https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
  for_each                = var.private_subnetmap
  vpc_id                  = aws_vpc.algvpc.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = each.value.map_public_ip_on_launch # Set to true if you want instances in this subnet to have public IP addresses
  tags = {
    Name    = "algsubnet-pvt-${each.key}"
    Project = var.project
  }
}

resource "aws_subnet" "pbl_subnets" {
  #https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
  for_each                = var.public_subnetmap
  vpc_id                  = aws_vpc.algvpc.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = each.value.map_public_ip_on_launch # Set to true if you want instances in this subnet to have public IP addresses
  tags = {
    Name    = "algsubnet-pbl-${each.key}"
    Project = var.project
  }
}


resource "aws_internet_gateway" "infra_igw" {
  #https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
  #error# depends_on = aws_vpc.algvpc
  vpc_id = aws_vpc.algvpc.id
  tags = {
    Name    = "AL Internet Gateway"
    Project = var.project
  }
}

resource "aws_route" "nat_route_entry" {
  #https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route.html
  depends_on             = [aws_nat_gateway.infra_natgwy]
  route_table_id         = data.aws_route_table.main.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.infra_natgwy.id

}

resource "aws_route_table" "public_rtb" {
  #https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table

  # "This route table is to be associated  only with public subnets"
  # It allows route to internet as well as to all subnets in VPC

  vpc_id = aws_vpc.algvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.infra_igw.id
  }
  /*
  route {
    cidr_block = aws_vpc.algvpc.cidr_block
    local_gateway_id = "local"
  }
  */
}

/*
resource "aws_route_table_association" "tst_public_rtb_assc" {
  #https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
  #for_each       = var.public_subnetmap
  #subnet_id      = each.key{each.value}.id
  #### subnet_id      = each.value.id
  subnet_id      = aws_subnet.tst_subnet.id
  route_table_id = aws_route_table.public_rtb.id
}
*/


resource "aws_route_table_association" "public_rtb_assc" {
  #https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
  for_each  = var.public_subnetmap
  subnet_id = aws_subnet.pbl_subnets[each.key].id
  #subnet_id = keys(each.value).id
  #### subnet_id      = each.value.id
  #subnet_id = aws_subnet.tst_subnet.id
  route_table_id = aws_route_table.public_rtb.id
}

resource "aws_eip" "infra_natgwy_eip" {
  #https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip.html
  #domain     = "vpc"
  depends_on = [aws_internet_gateway.infra_igw]
  tags = {
    Name    = "infra-netgwy-eip01"
    Project = var.project
  }

}

resource "aws_nat_gateway" "infra_natgwy" {
  #https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway
  depends_on        = [aws_eip.infra_natgwy_eip]
  subnet_id         = aws_subnet.pbl_subnets["sb1"].id
  connectivity_type = "public"
  allocation_id     = aws_eip.infra_natgwy_eip.id
  tags = {
    Name    = "infra-netgwy01"
    Project = var.project
  }
}

/*
resource "aws_launch_template" "infra_launch_template" {
  #https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template
  description            = "The AutoScaler Launch Templat e for scaling EC2 instances"
  image_id               = data.aws_ami.amzlinux.id
  key_name               = "Al-appserver-kp-poc-01"
  vpc_security_group_ids = [aws_security_group.webapp_security_group.id]
  instance_type          = "t2.micro"
  user_data              = filebase64(".\\scripts\\apache-install.sh")

#  placement {
#    availability_zone = "us-east-1a, us-east-1b" # <--- Get this right for multiple AZ
#   #availability_zone = values(var.private_subnetmap[*].az)

#  }
  
  tag_specifications {
    resource_type = "instance"

    tags = {
      Project = var.project
      Name    = "infra-web-instance"
    }
  }
  tags = {
    Name    = "infra-launch-tmpl01"
    Project = var.project
  }
}

resource "aws_autoscaling_group" "autos_grp01" {
  #https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group

  depends_on       = [aws_nat_gateway.infra_natgwy, aws_route.nat_route_entry]
  name             = "infra-autos01"
  desired_capacity = 2
  max_size         = 4
  min_size         = 1
  #availability_zones = ["us-east-1a", "us-east-1b"] # <--- Get this right for multiple AZ
  #for_each = var.private_subnetmap
  ## vpc_zone_identifier = [for subn in var.private_subnetmap : subn.az] #each.value.az #values(var.private_subnetmap["${keys(var.private_subnetmap)}"].id)  # <----- Left off here
  vpc_zone_identifier = [for subn in aws_subnet.pvt_subnets : subn.id]
  launch_template {
    name    = aws_launch_template.infra_launch_template.name
    version = "$Latest"
  }
}

resource "aws_autoscaling_attachment" "autos_attch01" {
  #https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_attachment
  autoscaling_group_name = aws_autoscaling_group.autos_grp01.id
  #elb                    = aws_lb.alg_alb.name
  lb_target_group_arn = aws_lb_target_group.webapp_tgtgrp.arn
}
*/

/*
resource "aws_instance" "pvt_ec2s" {
  #https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
  depends_on             = [aws_nat_gateway.infra_natgwy, aws_route.nat_route_entry]
  for_each               = var.private_subnetmap
  ami                    = data.aws_ami.amzlinux.id
  instance_type          = var.ec2_instance_type
  subnet_id              = aws_subnet.pvt_subnets[each.key].id
  key_name               = "Al-appserver-kp-poc-01"
  user_data              = file(".\\scripts\\apache-install.sh")
  vpc_security_group_ids = [aws_security_group.webapp_security_group.id]
  tags = {
    Name    = "algweb-pvt-ec2-${each.key}"
    Project = var.project
  }
}
*/
resource "aws_iam_instance_profile" "pbl_ec2_jump_profile" {
  name = "pbl-ec2-jump-profile"
  role = aws_iam_role.infra_ec2_role.name
}

resource "aws_instance" "pbl_ec2_jump" {
  #https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance

  depends_on             = [aws_internet_gateway.infra_igw, aws_route_table.public_rtb, aws_route_table_association.public_rtb_assc["sb1"]]
  ami                    = data.aws_ami.amzlinux.id
  instance_type          = var.ec2_instance_type
  subnet_id              = aws_subnet.pbl_subnets["sb1"].id
  key_name               = "Al-appserver-kp-poc-01"
  user_data              = file(".\\scripts\\utility-install.sh")
  vpc_security_group_ids = [aws_security_group.public_security_group.id]
  iam_instance_profile   = aws_iam_instance_profile.pbl_ec2_jump_profile.name
  tags = {
    Name    = "algweb-pbl-ec2_jump"
    Project = var.project
  }
}

resource "aws_iam_role" "infra_ec2_role" {
  name = "EC2-Role"
  path = "/"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "Service" : "ec2.amazonaws.com"
          },
          "Effect" : "Allow"
        }
      ]
    }
  )
}


resource "aws_iam_role_policy_attachment" "ec2_role_attch" {
  role       = aws_iam_role.infra_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

/*
resource "aws_lb" "alg_alb" {
  #https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb.html
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.public_security_group.id]
  subnets                    = [for pbl_subnet in aws_subnet.pbl_subnets : pbl_subnet.id]
  enable_deletion_protection = false # ----- If this was real world this would be true -----
  /*
#  access_logs {
#    bucket = aws_s3_bucket.lb_logs.id
#    prefix  = "alg-alb-accesslog"
#    enabled = true
#  }
#  connection_logs {
#    bucket = aws_s3_bucket.lb_logs.id
#    prefix  = "alg-alb-connectlog"
#    enabled = true
#  }

  tags = {
    Name    = "algweb-alb"
    Project = var.project
  }
}

resource "aws_lb_listener" "http_listener" {
  #https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
  load_balancer_arn = aws_lb.alg_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webapp_tgtgrp.arn #<------- Update
  }
  tags = {
    Name    = "algweb-alb-listener-80"
    Project = var.project
  }
}
*/

/*
resource "aws_lb_listener" "https_listener" {
  #https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
  load_balancer_arn = aws_lb.alg_alb.arn
  port              = "443"
  protocol          = "HTTPS"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webapp_tgtgrp.arn #<------- Update
  }
  tags = {
    Name    = "algweb-alb-listener-443"
    Project = var.project
  }
}
*/

/*
resource "aws_lb_target_group" "webapp_tgtgrp" {
  #https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
  #name       = "my-app-eg1"
  port       = 80 #<------- Port on which targets receive traffic
  protocol   = "HTTP"
  vpc_id     = aws_vpc.algvpc.id
  slow_start = 0

  load_balancing_algorithm_type = "round_robin"

  stickiness {
    enabled = false
    type    = "lb_cookie"
  }

  health_check {
    enabled             = true
    port                = 80
    interval            = 30
    protocol            = "HTTP"
    path                = "/"
    matcher             = "200"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
  tags = {
    Name    = "algweb-alb-target-group"
    Project = var.project
  }
}
*/

/*
# <--- This is no longer neded because we are using auto scaling attachment --->
resource "aws_lb_target_group_attachment" "webapp_tgtgrp_atthmnt" {
  #https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment
  for_each = aws_instance.pvt_ec2s

  target_group_arn = aws_lb_target_group.webapp_tgtgrp.arn
  target_id        = each.value.id
  port             = 80
}
*/
resource "null_resource" "update_docs" {

  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = "terraform-docs.exe markdown  ./ --output-file README.md"
    #command = "${C:\ProgramData\chocolatey\bin\}terraform-docs.exe markdown   --output-file README.md"
    #interpreter = ["powershell", "-File"]
  }
}


/*
resource "aws_route" "name" {
  route_table_id         = aws_vpc.algvpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.infra_igw.id
}
*/

/*
This Doesn't work, looks like I need to use a map
resource "aws_subnet" "algsubnets" {
  for_each               = toset(data.aws_availability_zones.all_zones.names)
  vpc_id                 = aws_vpc.algvpc.id
  #cidr_block             = "10.0.${each.key + 1}.0/24" # Example CIDR block, adjust as needed
  #cidr_block             = "10.0.${each.key + 1}.0/24" # Example CIDR block, adjust as needed
  cidr_block             = "10.0.${substr(each.key,8,1)}.0/24" # Example CIDR block, adjust as needed
  availability_zone      = each.value
  #map_public_ip_on_launch = true  # Set to true if you want instances in this subnet to have public IP addresses

  tags = {
    #Name = "algsubnet-${each.key + 1}"
    Name = "algsubnet-${each.key}"
  }
}
*/

/*
resource "aws_subnet" "algsubnets" {
  for_each               = {for n in (data.aws_availability_zones.all_zones.names): n.name => n01/18/2024 }
  vpc_id                 = aws_vpc.algvpc.id
  #cidr_block             = "10.0.${each.key + 1}.0/24" # Example CIDR block, adjust as needed
  #cidr_block             = "10.0.${each.key + 1}.0/24" # Example CIDR block, adjust as needed
  cidr_block             = "10.0.${each.key}.0/24" # Example CIDR block, adjust as needed
  availability_zone      = each.value
  #map_public_ip_on_launch = true  # Set to true if you want instances in this subnet to have public IP addresses

  tags = {
    #Name = "algsubnet-${each.key + 1}"
    Name = "algsubnet-${each.key}"
  }
}

*/