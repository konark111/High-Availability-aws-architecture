provider "aws" {
  region = var.region
}

# create vpc
module "vpc" {
    source = "../modules/vpc"
    region = var.region
    project_name = var.project_name
    vpc_cidr = var.vpc_cidr
    public_subnet_az1_cidr = var.public_subnet_az1_cidr
    az1 = var.az1
    public_subnet_az2_cidr = var.public_subnet_az2_cidr
    az2 = var.az2
    private_appsubnet_az1_cidr = var.private_appsubnet_az1_cidr
    private_appsubnet_az2_cidr = var.private_appsubnet_az2_cidr
    private_datasubnet_az1_cidr = var.private_datasubnet_az1_cidr
    private_datasubnet_az2_cidr = var.private_datasubnet_az2_cidr
    #######
    #key = file("./id_rsa.pub")
    ami = var.ami
    instance_type = var.instance_type
    #subnet_id = var.public_subnet_az2
    #public_subnet_az2 = var.public_subnet_az2
    #private_appsubnet_az2 = var.public_subnet_az2
}
