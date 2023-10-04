region = "us-east-1"
project_name = "saturn"
vpc_cidr = "10.0.0.0/16"
public_subnet_az1_cidr = "10.0.0.0/24"
az1 = "us-east-1a"
public_subnet_az2_cidr = "10.0.1.0/24"
az2 = "us-east-1b"
private_appsubnet_az1_cidr = "10.0.2.0/24"
private_appsubnet_az2_cidr = "10.0.3.0/24"
private_datasubnet_az1_cidr = "10.0.4.0/24"
private_datasubnet_az2_cidr = "10.0.5.0/24"
#####
ami = "ami-0261755bbcb8c4a84"
instance_type = "t2.small"
# key = file("${path.module}/id_rsa.pub")
#public_subnet_az2 = "aws_subnet.public_subnet_az1"
#private_appsubnet_az2 = "aws_subnet.private_appsubnet_az2.id"


