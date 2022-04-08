resource "aws_vpc" "prod-vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    enable_classiclink = "false"
    instance_tenancy = "default"

    tags = {
        Name = "prod-vpc"
    }
}

resource "aws_subnet" "prod-subnet-public-1" {
    vpc_id = "${aws_vpc.prod-vpc.id}"
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true" //it makes this a public subnet
    availability_zone = "ap-northeast-1a"

    tags = {
        Name = "prod-subnet-public-1"
    }
}

resource "aws_subnet" "prod-subnet-public-2" {
    vpc_id = "${aws_vpc.prod-vpc.id}"
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = "true" //it makes this a public subnet
    availability_zone = "ap-northeast-1c"

    tags = {
        Name = "prod-subnet-public-2"
    }
}

resource "aws_subnet" "prod-subnet-public-3" {
    vpc_id = "${aws_vpc.prod-vpc.id}"
    cidr_block = "10.0.3.0/24"
    map_public_ip_on_launch = "false" //it makes this a public subnet
    availability_zone = "ap-northeast-1c"

    tags = {
        Name = "prod-subnet-public-2"
    }
}

resource "aws_network_interface" "foo" {
  subnet_id   = aws_subnet.prod-subnet-public-1.id
  private_ips = ["10.0.1.100"]
  security_groups = ["${aws_security_group.ssh-allowed.id}"]

  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_network_interface" "foo_2" {
  subnet_id   = aws_subnet.prod-subnet-public-2.id
  private_ips = ["10.0.2.100"]
  security_groups = ["${aws_security_group.ssh-allowed.id}"]

  tags = {
    Name = "primary_network_interface_2"
  }
}

resource "aws_network_interface" "foo_3" {
  subnet_id   = aws_subnet.prod-subnet-public-2.id
  private_ips = ["10.0.2.101"]
  security_groups = ["${aws_security_group.ssh-allowed.id}"]

  tags = {
    Name = "primary_network_interface_3"
  }
}

resource "aws_network_interface" "detachable" {
  subnet_id   = aws_subnet.prod-subnet-public-3.id
  private_ips = ["10.0.3.100"]
  security_groups = ["${aws_security_group.ssh-allowed.id}"]

  tags = {
    Name = "detachable"
  }
}