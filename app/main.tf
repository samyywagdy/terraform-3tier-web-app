module "vpc" {
  source        = "../modules/vpc"
  PROJECT_NAME  = var.PROJECT_NAME
  VPC_CIDR      = var.VPC_CIDR
  VPC_1A_SUBNET = var.PUB_SUB_1A_CIDR
  VPC_1B_SUBNET = var.PUB_SUB_1B_CIDR
  VPC_2A_SUBNET = var.PRI_SUB_2A_CIDR
  VPC_2B_SUBNET = var.PRI_SUB_2B_CIDR
  VPC_3A_SUBNET = var.PRI_SUB_3A_CIDR
  VPC_3B_SUBNET = var.PRI_SUB_4B_CIDR
}

module "sg" {
  source   = "../modules/sg"
  VPC_ID   = module.vpc.VPC_ID
  VPC_CIDR = module.vpc.VPC_CIDR
}

module "key" {
  
  source = "../modules/key"
}

module "instance" {
  source        = "../modules/ec2"
  EC2_TYPE      = var.EC2_TYPE
  KEY_NAME      = module.key.DEVOPS_KEY
  PUB_SUB_1A_ID = module.vpc.PUB_SUB_1A_ID
  SSH_SG_ID     = module.sg.SSH_SG_ID
}

module "alb" {
  source        = "../modules/alb"
  PROJECT_NAME  = module.vpc.PROJECT_NAME
  VPC_ID        = module.vpc.VPC_ID
  PUB_SUB_1A_ID = module.vpc.PUB_SUB_1A_ID
  PUB_SUB_1B_ID = module.vpc.PUB_SUB_1B_ID
  ALB_SG_ID     = module.sg.ALB_SG_ID
  CERT_ARN      = module.acm.CERT_ARN
}

module "asg" {
  source        = "../modules/asg"
  PROJECT_NAME  = module.vpc.PROJECT_NAME
  EC2_TYPE      = module.instance.EC2_TYPE
  CLIENT_SG_ID  = module.sg.CLIENT_SG_ID
  SSH_SG_ID     = module.sg.SSH_SG_ID
  PRI_SUB_2A_ID = module.vpc.PUB_SUB_2A_ID
  PRI_SUB_2B_ID = module.vpc.PUB_SUB_2B_ID
  TG_ARN        = module.alb.TG_ARN
  KEY_NAME      = module.key.DEVOPS_KEY
}

module "db" {
  source            = "../modules/rds"
  DB_SUB_GROUP_NAME = var.DB_SUB_GROUP_NAME
  PUB_SUB_3A_ID     = module.vpc.PUB_SUB_3A_ID
  PUB_SUB_3B_ID     = module.vpc.PUB_SUB_3B_ID
  DB_USERNAME       = var.DB_USERNAME
  DB_PASSWORD       = var.DB_PASSWORD
  DB_SG_ID          = module.sg.DB_SG_ID
}

module "secrets" {
  source      = "../modules/secret-manager"
  DB_ENDPOINT = module.db.DB_ENDPOINT
  DB_USERNAME = module.db.DB_USERNAME
  DB_PASSWORD = module.db.DB_PASSWORD
}


module "cloudfront" {
  source          = "../modules/cloudfront"
  ALB_DOMAIN_NAME = module.alb.ALB_DOMAIN_NAME
  CERT_ARN        = module.acm.CERT_ARN
}
module "route53" {
  source                    = "../modules/route53"
  HOSTED_ZONE_NAME          = var.HOSTED_ZONE_NAME
  CLOUDFRONT_DOMAIN_NAME    = module.cloudfront.CLOUDFRONT_DOMAIN_NAME
  CLOUDFRONT_HOSTED_ZONE_ID = module.cloudfront.CLOUDFRONT_HOSTED_ZONE_ID
}


module "acm" {
  source       = "../modules/acm"
  DOMAIN_NAME  = var.HOSTED_ZONE_NAME
  PROJECT_NAME = module.vpc.PROJECT_NAME
}
