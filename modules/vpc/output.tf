output "region" {
  value = var.region
}
output "project_name" {
  value = var.project_name
}
output "vpc_id" {
  value = aws_vpc.vpc.id
}
output "public_subnet_az1_id" {
  value = aws_subnet.public_subnet_az1.id
}
output "public_subnet_az2_id" {
  value = aws_subnet.public_subnet_az2.id
}
output "private_appsubnet_az1_id" {
  value = aws_subnet.private_appsubnet_az1.id
}
output "private_appsubnet_az2_id" {
  value = aws_subnet.private_appsubnet_az2.id
}
output "private_datasubnet_az1_id" {
  value = aws_subnet.private_datasubnet_az1.id
}
output "private_datasubnet_az2_id" {
  value = aws_subnet.private_datasubnet_az2.id
}
output "internet_gateway" {
  value = aws_internet_gateway.internet_gateway
}
#######################################
output "ami" {
  value = var.ami
}
output "instance_type" {
  value = var.instance_type
}

