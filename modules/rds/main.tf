resource "aws_db_subnet_group" "default" {
  name       = var.DB_SUB_GROUP_NAME
  subnet_ids = [var.PUB_SUB_3A_ID, var.PUB_SUB_3B_ID]

  tags = {
    Name = "DB-subnet-group"
  }
}

resource "aws_db_instance" "mydb" {
  allocated_storage      = 20
  max_allocated_storage  = 100
  db_name                = "myapp_db"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  username               = var.DB_USERNAME
  password               = var.DB_PASSWORD
  db_subnet_group_name   = aws_db_subnet_group.default.name
  storage_encrypted      = false
  skip_final_snapshot    = true
  deletion_protection    = false # if we set it to "true" we cannot use terraform to delete the db
  vpc_security_group_ids = [var.DB_SG_ID]
}