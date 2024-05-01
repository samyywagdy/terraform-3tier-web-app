resource "aws_ssm_parameter" "db_endpoint" {
  name  = "db.endpoint"
  type  = "String"
  value = var.DB_ENDPOINT
}

resource "aws_ssm_parameter" "db_username" {
  name  = "db.username"
  type  = "String"
  value = var.DB_USERNAME
}

resource "aws_secretsmanager_secret" "db_password" {
  name                    = "db.pass"
  recovery_window_in_days = 0 // Overriding the default recovery window of 30 days
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = var.DB_PASSWORD
}