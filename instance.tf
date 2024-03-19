#This Terraform Code Deploys Basic VPC Infra.

resource "aws_vpc" "ProejctkVPC" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  tags = {
    projectid   = "${var.projectid}"
    projectname = "${var.projectname}"
    task        = "${var.taskname}"
    Name        = "${var.projectname}_${var.projectid}_${var.taskname}__VPC"
    environment = "${var.environment}"
  }
}

resource "aws_subnet" "Projectk-PublicSubnet" {
  vpc_id            = "${aws_vpc.ProejctkVPC.id}"
  cidr_block        = "${var.public_subnet_cidr}"
  availability_zone = "${var.availablezone}"

  tags = {
    Name = "${var.projectname}_${var.projectid}_${var.taskname}__Subnet"

  }
}

resource "aws_internet_gateway" "Projectk_InternetGateway" {
  vpc_id = "${aws_vpc.ProejctkVPC.id}"
  tags = {
    Name = "${var.projectname}_${var.projectid}_${var.taskname}__InternetGateway"
  }
}


resource "aws_route_table" "Projectk_RouteTable" {
  vpc_id = "${aws_vpc.ProejctkVPC.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.Projectk_InternetGateway.id}"
  }
  tags = {
    Name = "${var.projectname}_${var.projectid}_${var.taskname}_RouteTable"
  }
}

resource "aws_route_table_association" "Projectk_RoutetableAssociate" {
  subnet_id      = "${aws_subnet.Projectk-PublicSubnet.id}"
  route_table_id = "${aws_route_table.Projectk_RouteTable.id}"
}


resource "aws_security_group" "Projectk_SecurityGroup" {
  name        = "${var.projectname}_${var.projectid}_${var.taskname}__SG"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.ProejctkVPC.id}"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "ALL"
    #cidr_blocks = ["${var.trafficallow1}"]
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "ALL"
    #cidr_blocks = ["${var.trafficallow1}"]
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.projectname}_${var.projectid}_${var.taskname}_SG"
  }
}

resource "aws_instance" "VariableInstnace" {
  ami               = var.imagename
  availability_zone = "${var.availablezone}"
  instance_type     = var.instance_type
  key_name          = var.key_name
  subnet_id         = aws_subnet.Projectk-PublicSubnet.id
  #vpc_security_group_ids =  aws_security_group.Projectk_SecurityGroup.id
  vpc_security_group_ids      = ["${aws_security_group.Projectk_SecurityGroup.id}"]
  associate_public_ip_address = true
  user_data = "${file("installation.sh")}"
    tags = {
    Name  = "${var.projectname}_${var.projectid}_${var.taskname}_Instance"
    Env   = "var.environment"
    Owner = "Madhu"

  }

  provisioner "file" {
    source      = "D:/Madhu_labs/TerraForm/Terraform_AWS_InstanceCreationCode_WithOut_Variable/tomcat-users.xml"
    destination = "/home/ec2-user/"
  }

  connection {
    host        = self.public_ip
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("D:/Madhu_labs/Keys/ubuntu.pem")
  }

}
    