provider "aws" {
  region = var.region
}

module "sg" {
  source = "./modules/sg"
  vpc = module.vpc.vpc
  depends_on = [module.vpc]
}

module "key" {
  source   = "./modules/key"
  key_name = var.key_name
}

module "vpc" {
  source   = "./modules/vpc"
  availability_zones = var.availability_zones
}

module "ec2" {
  source          = "./modules/ec2"
  key_name        = module.key.wirevpn-key
  security_groups = module.sg.sg-out-main-sg-id
  availability_zones = var.availability_zones
  subnets = module.vpc.subnets
  depends_on = [
    module.sg,
    module.key,
    module.vpc
  ]
}

# ansible configuration
module "ansible" {
  source   = "./modules/ansible"
  depends_on = [module.ec2]
  ips = module.ec2.ips
}

/*
# block storage
module "ebs" {
  source   = "./modules/ebs"
  instances = [module.ec2.instances]
  depends_on = [module.ec2]
}
*/