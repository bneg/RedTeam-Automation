variable "pub_key" {}
variable "priv_key" {}

provider "aws" {
    region     = "us-west-2"
}

# AWS Key Pair
resource "aws_key_pair" "pubkey-empire-c2" {
  key_name = "${var.priv_key}"
  public_key = "${file(var.pub_key)}"
}

# AWS VPC
resource "aws_vpc" "vpc-empire-c2" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_subnet" "subnet-empire-c2" {
  vpc_id = "${aws_vpc.vpc-empire-c2.id}"
  cidr_block = "10.0.0.0/24"
}

resource "aws_internet_gateway" "gw-empire-c2" {
  vpc_id = "${aws_vpc.vpc-empire-c2.id}"
}

resource "aws_route_table" "route-empire-c2" {
  vpc_id = "${aws_vpc.vpc-empire-c2.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw-empire-c2.id}"
  }
}

resource "aws_route_table_association" "rt-empire-c2" {
  subnet_id = "${aws_subnet.subnet-empire-c2.id}"
  route_table_id = "${aws_route_table.route-empire-c2.id}"
}

# AWS Security Group (Firewall)
resource "aws_security_group" "sg-empire-c2" {
    name = "empire-c2-security-group"
    vpc_id = "${aws_vpc.vpc-empire-c2.id}"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 65534
        protocol = "udp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 65534
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "empire-server" {
    ami               = "ami-46a61a3e"
    instance_type     = "t2.micro"
    key_name          = "${var.priv_key}"
    vpc_security_group_ids = ["${aws_security_group.sg-empire-c2.id}"]
    subnet_id = "${aws_subnet.subnet-empire-c2.id}"
    associate_public_ip_address = true
    tags {
     Name = "empire-server"
      }

provisioner "local-exec" {
    command = "sleep 120; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ec2-user -b --private-key ${var.priv_key} -i '${aws_instance.empire-server.public_ip},' --extra-vars \"external_ip=${aws_instance.empire-server.public_ip}\" ../Ansible/Empire.yml"
  }
}

output "Empire C2 Server IP" {
    value = "${aws_instance.empire-server.public_ip}"
}

