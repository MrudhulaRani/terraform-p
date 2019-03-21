resource "aws_vpc" "vpc_tf" {
  cidr_block = "${var.cidr}"
  tags {
    Name="vpc-${var.project}"
  }
}

resource "aws_internet_gateway" "igw-tf" {
  vpc_id = "${aws_vpc.vpc_tf.id}"
  tags {
    Name="igw-${var.project}"
  }
}

resource "aws_route_table" "rt-tf" {
  vpc_id = "${aws_vpc.vpc_tf.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw-tf.id}"
  }
  tags {
    Name="rt-${var.project}"
  }
}


resource "aws_subnet" "sn-tf" {
  cidr_block = "${var.sn_cidr}"
  vpc_id = "${aws_vpc.vpc_tf.id}"
  map_public_ip_on_launch = true
  availability_zone = "${var.az}"
  tags {
    Name="sn-${var.project}"
  }
}

resource "aws_route_table_association" "rt-as-tf" {
  route_table_id = "${aws_route_table.rt-tf.id}"
  subnet_id = "${aws_subnet.sn-tf.id}"
}

resource "aws_security_group" "sg-tf" {
  name = "allow_ssh_http"
  description = "allow_ssh_http"
  vpc_id = "${aws_vpc.vpc_tf.id}"
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name="sg-${var.project}"
  }
}

resource "aws_instance" "vm-tf" {
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = "cli"
  subnet_id = "${aws_subnet.sn-tf.id}"
  security_groups = ["${aws_security_group.sg-tf.id}"]
  user_data = <<-EOF
  #!/bin/bash
  yum install nginx -y
  service nginx start
  EOF
tags {
  Name="vm-${var.project}"
}


}