variable "pub_key" {}
variable "priv_key" {}

# Providers
provider "aws" {
  region = "us-east-2"
}

# AWS Key Pair
resource "aws_key_pair" "id_rsa" {
  key_name = "id_rsa_tf"
  public_key = "${file(var.pub_key)}"
}

# AWS VPC
resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_subnet" "default" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "10.0.0.0/24"
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

resource "aws_route_table" "default" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }
}

resource "aws_route_table_association" "default" {
  subnet_id = "${aws_subnet.default.id}"
  route_table_id = "${aws_route_table.default.id}"
}

# AWS Security Group (Firewall)
resource "aws_security_group" "empire-server" {
    name = "empire-server"
    vpc_id = "${aws_vpc.default.id}"

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
        from_port = 53
        to_port = 53
        protocol = "udp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# AWS VPS
resource "aws_instance" "empire-server" {
  ami = "ami-10547475"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.id_rsa.key_name}"
  vpc_security_group_ids = ["${aws_security_group.empire-server.id}"]
  subnet_id = "${aws_subnet.default.id}"
  associate_public_ip_address = true

  provisioner "local-exec" {
    command = "sleep 120; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu --private-key '${var.priv_key},' -i '${aws_instance.empire-server.public_ip},' --extra-vars \"external_ip='${aws_instance.empire-server.public_ip},'\" Empire.yml"
  }
}
    
# Outputs
output "empire-server-ip" {
  value = "${aws_instance.empire-server.public_ip}"
}
