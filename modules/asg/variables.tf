variable "PROJECT_NAME" {}
variable "EC2_TYPE" {
  default = "t2.micro"
}
variable "DESIRED_SIZE" {
  default = 4
}
variable "MAX_SIZE" {
  default = 6
}
variable "MIN_SIZE" {
  default = 2
}
variable "AVAILABILTY_ZONES" {
  type    = list(any)
  default = ["us-east-1a"]
}
variable "CLIENT_SG_ID" {}
variable "SSH_SG_ID" {}
variable "PRI_SUB_2A_ID" {}
variable "PRI_SUB_2B_ID" {}
variable "TG_ARN" {}
variable "KEY_NAME" {}