resource "aws_key_pair" "DevOps_key" {
    key_name = "DevOps-key"
    public_key = file("../modules/key/devops_key.pub")
}