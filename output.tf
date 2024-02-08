# This is to guide what outputs are visible turing the terraform apply

output "vpcname" {
  description = "The name of the VPC  created"
  value       = aws_vpc.algvpc.tags.Name
}
output "vpcid" {
  description = "The AWS VPC ID of the VPC created"
  value       = aws_vpc.algvpc.id
}
output "vpcarn" {
  description = "The AWS VPC ARN of the VPC created"
  value       = aws_vpc.algvpc.arn
}
output "vpccidr" {
  description = "The AWS VPC IP address range of the VPC created"
  value       = aws_vpc.algvpc.cidr_block
}
output "mainrtb_id" {
  description = " The ID of the VPC's main route table"
  value       = aws_vpc.algvpc.main_route_table_id
}
output "infra_igw_id" {
  description = "The ID of the internet gateway"
  value       = aws_internet_gateway.infra_igw.id
}


output "subnet_ids" {
  description = " The id of the subnet created"
  value       = aws_subnet.pvt_subnets["sb1"].id
  #value = ${map(pvt_subnets)}.id
}

output "subnet_sb1_id" {
  description = " The id of the subnet created"
  value       = aws_subnet.pvt_subnets["sb1"].id
  #value = ${map(pvt_subnets)}.id
}
output "subnet_sb2_id" {
  description = " The id of the subnet created"
  value       = aws_subnet.pvt_subnets["sb2"].id
  #value = ${map(pvt_subnets)}.id
}
output "subnet_sb3_id" {
  description = " The id of the subnet created"
  value       = aws_subnet.pvt_subnets["sb3"].id
  #value = ${map(pvt_subnets)}.id
}
output "subnet_sb4_id" {
  description = " The id of the subnet created"
  value       = aws_subnet.pvt_subnets["sb4"].id
  #value = ${map(pvt_subnets)}.id
}


output "infra_natgwy_public_address" {
  description = "The Public IP address of the Nat Gateway"
  value       = aws_nat_gateway.infra_natgwy.public_ip
}

/*
output "autos_instances_ids" {
  description = "The initially generated EC2 instances"
  value       = data.aws_instances.autos_instances[*].ids
}

output "autos_instances_pvt_ips" {
  description = "The initially generated EC2 instances"
  value       = data.aws_instances.autos_instances[*].private_ips
}
*/


output "ec2_jump_id" {
  description = "The EC2 Jump ID"
  value       = aws_instance.pbl_ec2_jump.id
}
output "ec2_jump_ip" {
  description = "The EC2 Jump Private IP"
  value       = aws_instance.pbl_ec2_jump.private_ip
}
output "ec2_jump_pbl_ip" {
  description = "The EC2 Jump Public IP"
  value       = aws_instance.pbl_ec2_jump.public_ip
}
output "ec2_jump_pvt_dns" {
  description = "The EC2 Jump Public IP"
  value       = aws_instance.pbl_ec2_jump.public_dns
}

output "ec2_jump_profile_name" {
  description = "The EC2 profile that is used to attach a Role to the jump EC2 instance"
  value = aws_iam_instance_profile.pbl_ec2_jump_profile.name
}

output "ec2_jump_policies" {
  description = "The IAM policies being used by the EC2 Jump instance"
  value = aws_iam_role_policy_attachment.ec2_role_attch.policy_arn
}

output "ec2_jump_role_name" {
  description = "The EC2 Role that assumed by the jump EC2 instance"
  value = aws_iam_role.infra_ec2_role.name
}

/*
output "ec2_web_sb1_id" {
  description = "The EC2 sb1 ID"
  value       = aws_instance.pvt_ec2s["sb1"].id
}
output "ec2_web_sb1_pvt_ip" {
  description = "The EC2 sb1 Private IP"
  value       = aws_instance.pvt_ec2s["sb1"].private_ip
}
output "ec2_web_sb1_pbl_ip" {
  description = "The EC2 sb1 Public IP"
  value       = aws_instance.pvt_ec2s["sb1"].public_ip
}
output "ec2_web_sb1_pvt_dns" {
  description = "The EC2 sb1 Public IP"
  value       = aws_instance.pvt_ec2s["sb1"].public_dns
}

output "ec2_web_sb2_id" {
  description = "The EC2 sb2 ID"
  value       = aws_instance.pvt_ec2s["sb2"].id
}
output "ec2_web_sb2_pvt_ip" {
  description = "The EC2 sb2 Private IP"
  value       = aws_instance.pvt_ec2s["sb2"].private_ip
}
output "ec2_web_sb2_pbl_ip" {
  description = "The EC2 sb2 Public IP"
  value       = aws_instance.pvt_ec2s["sb2"].public_ip
}
output "ec2_web_sb2_pvt_dns" {
  description = "The EC2 sb2 Public IP"
  value       = aws_instance.pvt_ec2s["sb2"].public_dns
}

output "ec2_web_sb3_id" {
  description = "The EC2 sb3 ID"
  value       = aws_instance.pvt_ec2s["sb3"].id
}
output "ec2_web_sb3_pvt_ip" {
  description = "The EC2 sb3 Private IP"
  value       = aws_instance.pvt_ec2s["sb3"].private_ip
}
output "ec2_web_sb3_pbl_ip" {
  description = "The EC2 sb3 Public IP"
  value       = aws_instance.pvt_ec2s["sb3"].public_ip
}
output "ec2_web_sb3_pvt_dns" {
  description = "The EC2 sb3 Public IP"
  value       = aws_instance.pvt_ec2s["sb3"].public_dns
}

output "ec2_web_sb4_id" {
  description = "The EC2 sb4 ID"
  value       = aws_instance.pvt_ec2s["sb4"].id
}
output "ec2_web_sb4_pvt_ip" {
  description = "The EC2 sb4 Private IP"
  value       = aws_instance.pvt_ec2s["sb4"].private_ip
}
output "ec2_web_sb4_pbl_ip" {
  description = "The EC2 sb4 Public IP"
  value       = aws_instance.pvt_ec2s["sb4"].public_ip
}
output "ec2_web_sb4_pbl_dns" {
  description = "The EC2 sb4 Public IP"
  value       = aws_instance.pvt_ec2s["sb4"].public_dns
}


output "web_alb_id" {
  description = "The ID of the Application Load Balancer for Web traffic"
  value       = aws_lb.alg_alb.id
}
output "web_alb_dnsname" {
  description = "The DNS Name of the Application Load Balancer for Web traffic"
  value       = aws_lb.alg_alb.dns_name
}
output "web_alb_zoneid" {
  description = "The Zone ID of the Application Load Balancer for Web traffic"
  value       = aws_lb.alg_alb.zone_id
}
output "web_alp_httplistener_id" {
  description = "The ID of the ALB HTTP listener"
  value       = aws_lb_listener.http_listener.id
}
output "web_alp_httpslistener_id" {
  description = "The ID of the ALB HTTPS listener"
  value       = aws_lb_listener.http_listener.id
}
*/

/*
output "autos_grp01_id" {
  description = "The ID of the Austoscaling group 01"
  value       = aws_autoscaling_group.autos_grp01.id
}

output "autos_grp01_zones" {
  description = "The Availability Zones used by Austoscaling group 01"
  value       = aws_autoscaling_group.autos_grp01.availability_zones
}
*/