# create security group for the application load balancer "ALB"
resource "aws_security_group" "alb_sg" {
  name        = "ALB SG"
  description = "Allow http/https inbound traffic"
  vpc_id      = var.VPC_ID

  ingress {
    description      = "http access"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "https access"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1" #Any protocols
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "ALB-SG"
  }
}
# create security group for the Client
resource "aws_security_group" "client_sg" {
  name        = "client-sg"
  description = "Allow http/https on port 80 for elb sg"
  vpc_id      = var.VPC_ID

  ingress {
    description     = "http access"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Client-sg"
  }
}

# create security group for the Database
resource "aws_security_group" "db_sg" {
  name        = "DB-SG"
  description = "enable mysql access on port 3306 from client-sg"
  vpc_id      = var.VPC_ID

  ingress {
    description     = "mysql access"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.client_sg.id]
    cidr_blocks     = [var.VPC_CIDR]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Database-sg"
  }
}

resource "aws_security_group" "ssh_sg" {
  name        = "ssh_sg"
  description = "securtiy group ssh access "
  vpc_id      = var.VPC_ID

  ingress {
    description = "ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SSH_SG"
  }
}