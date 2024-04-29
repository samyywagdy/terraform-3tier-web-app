output "PROJECT_NAME" {
  value = var.PROJECT_NAME
}

output "VPC_ID" {
  value = aws_vpc.vpc.id
}

output "PUB_SUB_1A_ID" {
  value = aws_subnet.public-subnet-1a.id
}

output "PUB_SUB_1B_ID" {
  value = aws_subnet.public-subnet-1b.id
}

output "PUB_SUB_2A_ID" {
  value = aws_subnet.private-subnet-2a.id
}

output "PUB_SUB_2B_ID" {
  value = aws_subnet.private-subnet-2b.id
}

output "PUB_SUB_3A_ID" {
  value = aws_subnet.private-subnet-3a.id
}

output "PUB_SUB_3B_ID" {
  value = aws_subnet.private-subnet-3b.id
}

output "IGW_ID" {
  value = aws_internet_gateway.igw
}
output "VPC_CIDR" {
  value = aws_vpc.vpc.cidr_block
}