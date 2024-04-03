#### AMI for Nodes
#### find the lastest ami for ubuntu 18.04 x86 server
#### find the ami for ubuntu 20.04 x86 server

#ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20240321
# "ubuntu\\/images\\/hvm-ssd\\/ubuntu-focal-20.04-amd64-server-20240321"
#old 18.04
# "ubuntu\\/images\\/hvm-ssd\\/ubuntu-bionic-18.04-amd64-server"
data "aws_ami" "ami" {
  most_recent = true
  name_regex  = "ubuntu\\/images\\/hvm-ssd\\/ubuntu-focal-20.04-amd64-server-20240321"
  # This is Canonical's ID (find here: https://ubuntu.com/server/docs/cloud-images/amazon-ec2)
  owners = ["099720109477"]

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "ena-support"
    values = [var.ena-support]
  }
}