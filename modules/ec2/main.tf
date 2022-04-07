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

resource "aws_instance" "ubuntu" {
  ami             = data.aws_ami.ubuntu.id
  count           = length(var.availability_zones)
  instance_type   = "t2.micro"
  key_name        = "aws_key"
  vpc_security_group_ids = [var.security_groups]
  subnet_id       = var.subnets[count.index].id
  tags = {
    Name = "ubuntu"
  }
}