variable "PROJECT_NAME" {}
variable "REGION" {}
variable "VPC_CIDR" {}
variable "PUB_SUB_1A_CIDR" {}
variable "PUB_SUB_1B_CIDR" {}
variable "PRI_SUB_2A_CIDR" {}
variable "PRI_SUB_2B_CIDR" {}
variable "PRI_SUB_3A_CIDR" {}
variable "PRI_SUB_4B_CIDR" {}
variable "EC2_TYPE" {}
variable "KEY_NAME" {}
variable "DB_SUB_GROUP_NAME" {
  default = "book-shop-db-subnet-a-b"
}
variable "DB_USERNAME" {}
variable "DB_PASSWORD" {}

variable "HOSTED_ZONE_NAME" {}