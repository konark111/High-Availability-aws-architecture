# create VPC 
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}
resource "aws_security_group" "ssh-access" {
  name   = "ssh-access"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
# create prublic subnet in az1
resource "aws_subnet" "public_subnet_az1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_az1_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.az1
  tags = {
    Name = "Publicsubnet_az1"
  }
}
# create prublic subnet in az2
resource "aws_subnet" "public_subnet_az2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_az2_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.az2
  tags = {
    Name = "Publicsubnet_az2"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags = {
    Name = "public_RT"
  }
}
resource "aws_route_table_association" "public_subnet_az1_rt_association" {
  subnet_id      = aws_subnet.public_subnet_az1.id
  route_table_id = aws_route_table.public_route_table.id
}
resource "aws_route_table_association" "public_subnet_az2_rt_association" {
  subnet_id      = aws_subnet.public_subnet_az2.id
  route_table_id = aws_route_table.public_route_table.id
}
# private app subnet
resource "aws_subnet" "private_appsubnet_az1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_appsubnet_az1_cidr
  availability_zone = var.az1
  #  map_public_ip_on_launch = true

  tags = {
    Name = "Private_appsubnet_az1"
  }
}
# private app subnet
resource "aws_subnet" "private_appsubnet_az2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_appsubnet_az2_cidr
  availability_zone = var.az2
  #  map_public_ip_on_launch = true

  tags = {
    Name = "Private_appsubnet-az2"
  }
}
# private data subnet az1
resource "aws_subnet" "private_datasubnet_az1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_datasubnet_az1_cidr
  availability_zone = var.az1
  #  map_public_ip_on_launch = true

  tags = {
    Name = "Private_datasubnet_az1"
  }
}
# private data subnet az2
resource "aws_subnet" "private_datasubnet_az2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_datasubnet_az2_cidr
  availability_zone = var.az2
  #  map_public_ip_on_launch = true

  tags = {
    Name = "Private_datasubnet-az2"
  }
}
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "example-subnet-group"
  subnet_ids = [aws_subnet.private_datasubnet_az1.id, aws_subnet.private_datasubnet_az2.id]
}

resource "aws_db_instance" "example2" {
  allocated_storage = 20
  storage_type      = "gp2"
  engine            = "mysql"
  engine_version    = "5.7"
  instance_class    = "db.t2.micro"
  #  name                 = "example-instance"
  username               = "admin1"
  password               = "Zicco312#" # Replace with your desired password
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true # To avoid creating a final snapshot when destroying
  vpc_security_group_ids = [aws_security_group.ssh-access.id]
  # Enable Multi-AZ deployment for high availability
  multi_az = true

  # Specify the subnet group name here
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name

  # Enable the free tier for RDS (requires custom engine settings)
  apply_immediately = true

  # Tags for the RDS instance
  tags = {
    Name = "rds1-instance"
  }
}
#########################################################
resource "aws_route_table" "private_az1route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-1.id
  }
  tags = {
    Name = "Private_rt_1"
  }
}
resource "aws_route_table" "private_az2route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-2.id
  }
  tags = {
    Name = "private_rt_2"
  }
}



resource "aws_route_table_association" "private_appsubnet_az1_rt_association" {
  subnet_id      = aws_subnet.private_appsubnet_az1.id
  route_table_id = aws_route_table.private_az1route_table.id
}
resource "aws_route_table_association" "private_datasubnet_az1_rt_association" {
  subnet_id      = aws_subnet.private_datasubnet_az1.id
  route_table_id = aws_route_table.private_az1route_table.id
}
resource "aws_route_table_association" "private_appsubnet_az2_rt_association" {
  subnet_id      = aws_subnet.private_appsubnet_az2.id
  route_table_id = aws_route_table.private_az2route_table.id
}
resource "aws_route_table_association" "private_datasubnet_az2_rt_association" {
  subnet_id      = aws_subnet.private_datasubnet_az2.id
  route_table_id = aws_route_table.private_az2route_table.id
}
resource "aws_eip" "eip-nat-1" {
  #  instance = aws_instance.web.id
  vpc        = true
  depends_on = [aws_internet_gateway.internet_gateway]
}
resource "aws_nat_gateway" "nat-1" {
  allocation_id = aws_eip.eip-nat-1.id
  subnet_id     = aws_subnet.public_subnet_az1.id
  tags = {
    Name = "NAT-1"
  }
}
resource "aws_eip" "eip-nat-2" {
  #  instance = aws_instance.web.id
  vpc        = true
  depends_on = [aws_internet_gateway.internet_gateway]
}
resource "aws_nat_gateway" "nat-2" {
  allocation_id = aws_eip.eip-nat-2.id
  subnet_id     = aws_subnet.public_subnet_az2.id
  tags = {
    Name = "NAT-2"
  }
}
resource "aws_instance" "server1" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.web.key_name
  subnet_id              = aws_subnet.public_subnet_az2.id
  vpc_security_group_ids = [aws_security_group.ssh-access.id]
  #user_data              = file("ins_script.sh")
  #  count = 5
  tags = {
    Name = "${var.project_name}-pub-ec2"
    #    Name = "Public-jump-${format("%02d", count.index + 1)}"
  }

}

resource "aws_instance" "server2" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.web.key_name
  subnet_id              = aws_subnet.private_appsubnet_az1.id
  vpc_security_group_ids = [aws_security_group.ssh-access.id]
  #    user_data              = file("ins_script.sh")
  count = 2
  tags = {
    # Name = "${var.project_name}-private-app-ec2"
    Name = "private-ec2-az1-${format("%02d", count.index + 1)}"
  }

}
resource "aws_instance" "server3" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.web.key_name
  subnet_id              = aws_subnet.private_appsubnet_az2.id
  vpc_security_group_ids = [aws_security_group.ssh-access.id]
  #    user_data              = file("ins_script.sh")
  count = 2
  tags = {
    # Name = "${var.project_name}-private-app-ec2"
    Name = "private-ec2-az2-${format("%02d", count.index + 1)}"
  }

}
resource "aws_key_pair" "web" {
  key_name   = "id_rsa"
  public_key = file("./id_rsa.pub")
}


output "public-ip" {
  value = aws_instance.server1.*.public_ip
}
resource "aws_lb" "demo" {
  name                       = "test-lb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.ssh-access.id]
  subnets                    = [aws_subnet.public_subnet_az1.id, aws_subnet.public_subnet_az2.id]
  ip_address_type            = "ipv4"
  enable_deletion_protection = false


  tags = {
    Environment = "production"
  }
}
resource "aws_lb_target_group" "lb-tg" {
  name        = "test-lb-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "instance"

  health_check {
    enabled             = true
    interval            = 300
    path                = "/"
    timeout             = 60
    matcher             = 200
    healthy_threshold   = 5
    unhealthy_threshold = 5

  }
  lifecycle {

    create_before_destroy = false
  }
}
# create a listener on port 80 with redirect action
resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_lb.demo.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb-tg.arn
  }
}
# default_action {
#   type = "redirect"

#   redirect {
#     port        = 443
#     protocol    = "HTTPS"
#     status_code = "HTTP_301"
#   }
# }
resource "aws_lb_target_group_attachment" "test" {
  target_id        = aws_instance.server2[count.index].id
  count            = length(aws_instance.server2)
  target_group_arn = aws_lb_target_group.lb-tg.arn
  port             = 80

}
resource "aws_lb_target_group_attachment" "test1" {
  target_group_arn = aws_lb_target_group.lb-tg.arn
  count            = length(aws_instance.server3)
  target_id        = aws_instance.server3[count.index].id
  port             = 80

}

