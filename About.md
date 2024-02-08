

# Build Test Terraform Environment

>### **Project Description:**<br>
>This project is to test builing AWS Infrastructure using Terraform.<br>  
>The project builds out infrastructure to support an EC2 instance for O/S metrics into CloudWatch via CloudWatch Agent.<br>
>There is one EC2 instance built that assumes a role CloudWatchAgentServerPolicy<br>
>This is about skills development

>### **Details:**
>The following Infrastructure components are built:<br>
>- **VPC** - Foundational Component
>- **Private Subnets** - Support The Web EC2 instances
>- **Public Subnets** - Support external communications via Internet Gateway, and for Application Load Balancer + Jump EC2 instance
>- **Internet Gateway** - Facilitate internet traffic
>- **Nat Gateway** - Allow EC2 instances on private network to have egress access to internet, without exposing them
>- **Public Route Table** - Routes traffic to IGW
>- **Route Association** - Assigns route table to a subnet
>- **Security Group** - two security groups one for web EC2 instances, and the other for jump EC2 instance and the ALB
>- **EC2 Instances** - Jump instance for running CloudWatch Agent
>- **EC2 Profile Template** - Used to tell the EC2 instance what Role to assume
>- **IAM Role** Listener - Role to allow  EC2 instance to assume 
>- **IAM Role / Policy Attachment** Maps the CloudWatch Server Policy to the EC2 Role
> 


>### **Creator:**<br>
>**ALG**

