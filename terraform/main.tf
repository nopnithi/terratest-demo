terraform {
  required_version = ">= 0.12.26"
}

provider "aws" {
  region = "ap-southeast-1"
}

# Run an Ubuntu 20.04 AMI on the EC2 instance in ap-southeast-1
# and start a web server after it boots
resource "aws_instance" "example" {
  ami                    = data.aws_ami.ubuntu20.image_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.instance.id]
  user_data = <<-EOF
              #!/bin/bash
              echo "${var.instance_name}" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF
  tags = {
    Name = var.instance_name
  }
}

# Create a security group to allow the HTTP requests on a specified port
resource "aws_security_group" "instance" {
  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Get the latest Ubuntu 20.04 AMI ID
data "aws_ami" "ubuntu20" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "image-type"
    values = ["machine"]
  }

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}