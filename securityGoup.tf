# This is my template for a security group

resource "aws_security_group" "public_security_group" {
  name        = "public-security-group"
  description = "Public Security Group for HTTP, HTTPS, and SSH"
  vpc_id      = aws_vpc.algvpc.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    #cidr_blocks = ["0.0.0.0/0"] # Replace with a specific IP range or your own IP for more security
    cidr_blocks = ["${local.safe_ip}"] # Replace with a specific IP range or your own IP for more security
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "Infra Public SG"
    Project = var.project
  }
}

resource "aws_security_group" "webapp_security_group" {
  name        = "webapp-security-group"
  description = "Web Application Security Group for HTTP, HTTPS, and SSH"
  vpc_id      = aws_vpc.algvpc.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    #cidr_blocks = ["0.0.0.0/0"] # Replace with a specific IP range or your own IP for more security
    cidr_blocks = ["${aws_vpc.algvpc.cidr_block}"] # Replace with a specific IP range or your own IP for more security
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${aws_vpc.algvpc.cidr_block}"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${aws_vpc.algvpc.cidr_block}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "webapp SG"
    Project = var.project
  }
}