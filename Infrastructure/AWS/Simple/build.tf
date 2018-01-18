variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "vpc_id" {}
variable "pvt_key" {}


provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region     = "us-west-2"
}

resource "aws_security_group" "empire_c2_security_group" {
  name        = "empirec2-sg"
  description = "Empire C2 security group."
  vpc_id      = "${var.vpc_id}"
}

resource "aws_security_group_rule" "egress_access" {
  type = "egress"
  from_port = 0
  to_port = 65535
  protocol = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = "${aws_security_group.empire_c2_security_group.id}"
}

resource "aws_security_group_rule" "ssh_ingress_access" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ] 
  security_group_id = "${aws_security_group.empire_c2_security_group.id}"
}

resource "aws_security_group_rule" "ssh_http_access" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = "${aws_security_group.empire_c2_security_group.id}"
}

resource "aws_security_group_rule" "https_ingress_access" {
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = "${aws_security_group.empire_c2_security_group.id}"
}


resource "aws_security_group_rule" "http_alt_ingress_access" {
  type = "ingress"
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = "${aws_security_group.empire_c2_security_group.id}"
}

resource "aws_security_group_rule" "https_alt_ingress_access" {
  type = "ingress"
  from_port = 8443
  to_port = 8443
  protocol = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = "${aws_security_group.empire_c2_security_group.id}"
}

resource "aws_security_group_rule" "shell_1_ingress_access" {
  type = "ingress"
  from_port = 1337
  to_port = 1337
  protocol = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = "${aws_security_group.empire_c2_security_group.id}"
}

resource "aws_security_group_rule" "shell_2_ingress_access" {
  type = "ingress"
  from_port = 31337
  to_port = 31337
  protocol = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = "${aws_security_group.empire_c2_security_group.id}"
}


resource "aws_instance" "empire-server" {
    ami               = "ami-3fcd2747"
    instance_type     = "t2.micro"
    key_name          = "empire-c2"
    security_groups   = [ "${aws_security_group.empire_c2_security_group.name}" ]
    tags {
     Name = "empire-c2"
      }

provisioner "local-exec" {
    command = "sleep 120; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ec2-user -b --private-key ${var.pvt_key} -i '${aws_instance.empire-server.public_ip},' Empire.yml"
  }

provisioner "local-exec" {
    command = "sleep 60; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -vvvvv -u ec2-user -b --private-key ${var.pvt_key} -i '${aws_instance.empire-server.public_ip},' Screen.yml"
  }
}

output "Empire C2 Server IP" {
    value = "${aws_instance.empire-server.public_ip}"
}
