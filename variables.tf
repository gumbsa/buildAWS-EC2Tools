# Locals
locals {
  safe_ip = "104.6.208.173/32"
}

# Variables

variable "project" {
  description = "The name of this project"
  type        = string
  default     = "Build Test Terraform Environment"
}

variable "aws_region" {
  description = "The region we will build resources in"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "This is the CIDR address range to be used by the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnetmap" {
  description = "'Defines the Privat Subnets to be created"
  type        = map(map(string))

}

variable "public_subnetmap" {
  description = "'Defines the Public Subnets to be created"
  type        = map(map(string))

}

variable "ec2_instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t3.micro"
}