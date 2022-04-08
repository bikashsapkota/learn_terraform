data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_iam_instance_profile" "test_profile" {
  name = "test_profile"
  role = "db-instance-orient"
}

resource "aws_instance" "web" {
  ami           = "ami-00c408a8b71d5c614"
  instance_type = "t3.micro"
  key_name      = "development"
  iam_instance_profile = "${aws_iam_instance_profile.test_profile.name}"

  tags = {
    Name = "HelloWorld"
  }

  network_interface {
    network_interface_id = aws_network_interface.foo.id
    device_index         = 0
  }
}



resource "aws_instance" "web_2" {
  ami           = "ami-00c408a8b71d5c614"
  instance_type = "t3.micro"
  key_name      = "development"
#   security_groups = ["${aws_security_group.ssh-allowed.id}"]

  iam_instance_profile = "${aws_iam_instance_profile.test_profile.name}"
  user_data                   = <<EOF
#!/bin/bash -xe
sudo apt update
sudo apt upgrade -y
sudo hostnamectl set-hostname ubuntusrv.citizix.com
sudo apt install -y nginx vim
sudo cat > /var/www/html/hello.html <<EOD
Hello world!
EOD
EOF

  tags = {
    Name = "HelloWorld"
  }

  network_interface {
    network_interface_id = aws_network_interface.foo_2.id
    device_index         = 0
  }

}

resource "aws_eip" "lb" {
  instance = aws_instance.web_2.id
  vpc      = true
}

resource "aws_eip" "lb_1" {
  instance = aws_instance.web.id
  vpc      = true
}


# aws ec2 attach-network-interface \
#         --network-interface-id $NIC \
#         --instance-id $INSTANCE \
#         --device-index 1 \
#         --region $REGION