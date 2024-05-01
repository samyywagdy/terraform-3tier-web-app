data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "bastion-server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.EC2_TYPE
  key_name               = var.KEY_NAME
  subnet_id              = var.PUB_SUB_1A_ID
  vpc_security_group_ids = [var.SSH_SG_ID]
  tags = {
    Name = "Bastion-server"
  }
}