output "DB_ENDPOINT" {
  value = aws_db_instance.mydb.endpoint
}
output "DB_USERNAME" {
  value = aws_db_instance.mydb.username
}

output "DB_PASSWORD" {
  value = aws_db_instance.mydb.password
}