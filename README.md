<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.35.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ec2_serial_console_access.infra_tty](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_serial_console_access) | resource |
| [aws_eip.infra_natgwy_eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_iam_instance_profile.pbl_ec2_jump_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.infra_ec2_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ec2_role_attch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.pbl_ec2_jump](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_internet_gateway.infra_igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.infra_natgwy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route.nat_route_entry](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.public_rtb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.public_rtb_assc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.public_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.webapp_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.pbl_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.pvt_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.algvpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [null_resource.update_docs](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_ami.amzlinux](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_availability_zones.all_zones](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_route_table.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_table) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The region we will build resources in | `string` | `"us-east-1"` | no |
| <a name="input_ec2_instance_type"></a> [ec2\_instance\_type](#input\_ec2\_instance\_type) | EC2 Instance Type | `string` | `"t3.micro"` | no |
| <a name="input_private_subnetmap"></a> [private\_subnetmap](#input\_private\_subnetmap) | 'Defines the Privat Subnets to be created | `map(map(string))` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The name of this project | `string` | `"Build Test Terraform Environment"` | no |
| <a name="input_public_subnetmap"></a> [public\_subnetmap](#input\_public\_subnetmap) | 'Defines the Public Subnets to be created | `map(map(string))` | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | This is the CIDR address range to be used by the VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ec2_jump_id"></a> [ec2\_jump\_id](#output\_ec2\_jump\_id) | The EC2 Jump ID |
| <a name="output_ec2_jump_ip"></a> [ec2\_jump\_ip](#output\_ec2\_jump\_ip) | The EC2 Jump Private IP |
| <a name="output_ec2_jump_pbl_ip"></a> [ec2\_jump\_pbl\_ip](#output\_ec2\_jump\_pbl\_ip) | The EC2 Jump Public IP |
| <a name="output_ec2_jump_policies"></a> [ec2\_jump\_policies](#output\_ec2\_jump\_policies) | The IAM policies being used by the EC2 Jump instance |
| <a name="output_ec2_jump_profile_name"></a> [ec2\_jump\_profile\_name](#output\_ec2\_jump\_profile\_name) | The EC2 profile that is used to attach a Role to the jump EC2 instance |
| <a name="output_ec2_jump_pvt_dns"></a> [ec2\_jump\_pvt\_dns](#output\_ec2\_jump\_pvt\_dns) | The EC2 Jump Public IP |
| <a name="output_ec2_jump_role_name"></a> [ec2\_jump\_role\_name](#output\_ec2\_jump\_role\_name) | The EC2 Role that assumed by the jump EC2 instance |
| <a name="output_infra_igw_id"></a> [infra\_igw\_id](#output\_infra\_igw\_id) | The ID of the internet gateway |
| <a name="output_infra_natgwy_public_address"></a> [infra\_natgwy\_public\_address](#output\_infra\_natgwy\_public\_address) | The Public IP address of the Nat Gateway |
| <a name="output_mainrtb_id"></a> [mainrtb\_id](#output\_mainrtb\_id) | The ID of the VPC's main route table |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | The id of the subnet created |
| <a name="output_subnet_sb1_id"></a> [subnet\_sb1\_id](#output\_subnet\_sb1\_id) | The id of the subnet created |
| <a name="output_subnet_sb2_id"></a> [subnet\_sb2\_id](#output\_subnet\_sb2\_id) | The id of the subnet created |
| <a name="output_subnet_sb3_id"></a> [subnet\_sb3\_id](#output\_subnet\_sb3\_id) | The id of the subnet created |
| <a name="output_subnet_sb4_id"></a> [subnet\_sb4\_id](#output\_subnet\_sb4\_id) | The id of the subnet created |
| <a name="output_vpcarn"></a> [vpcarn](#output\_vpcarn) | The AWS VPC ARN of the VPC created |
| <a name="output_vpccidr"></a> [vpccidr](#output\_vpccidr) | The AWS VPC IP address range of the VPC created |
| <a name="output_vpcid"></a> [vpcid](#output\_vpcid) | The AWS VPC ID of the VPC created |
| <a name="output_vpcname"></a> [vpcname](#output\_vpcname) | The name of the VPC  created |
<!-- END_TF_DOCS -->