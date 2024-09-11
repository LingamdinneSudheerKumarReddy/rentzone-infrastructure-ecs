locals {
  region       = var.region
  project_name = var.project_name
  environment  = var.environment
}

# Create VPC module
module "vpc" {
  source                       = "git@github.com:Silas-cloudspace/terraform-modules.git//vpc"
  region                       = local.region
  project_name                 = local.project_name
  environment                  = local.environment
  vpc_cidr                     = var.vpc_cidr
  public_subnet_az1_cidr       = var.public_subnet_az1_cidr
  public_subnet_az2_cidr       = var.public_subnet_az2_cidr
  private_app_subnet_az1_cidr  = var.private_app_subnet_az1_cidr
  private_app_subnet_az2_cidr  = var.private_app_subnet_az2_cidr
  private_data_subnet_az1_cidr = var.private_data_subnet_az1_cidr
  private_data_subnet_az2_cidr = var.private_data_subnet_az2_cidr
}

# Create the nat-gateways
module "nat_gateway" {
  source                     = "git@github.com:Silas-cloudspace/terraform-modules.git//nat_gateway"
  project_name               = local.project_name
  environment                = local.environment
  public_subnet_az1_id       = module.vpc.public_subnet_az1_id
  internet_gateway           = module.vpc.internet_gateway
  public_subnet_az2_id       = module.vpc.public_subnet_az2_id
  vpc_id                     = module.vpc.vpc_id
  private_app_subnet_az1_id  = module.vpc.private_app_subnet_az1_id
  private_data_subnet_az1_id = module.vpc.private_data_subnet_az1_id
  private_app_subnet_az2_id  = module.vpc.private_app_subnet_az2_id
  private_data_subnet_az2_id = module.vpc.private_data_subnet_az2_id
}

# Create security groups
module "security_group" {
  source = "git@github.com:Silas-cloudspace/terraform-modules.git//security_groups"
  project_name = local.project_name
  environment = local.environment
  vpc_id = module.vpc.vpc_id
  ssh_ip = var.ssh_ip
}

# launch rds instance
module "rds" {
  source = "git@github.com:Silas-cloudspace/terraform-modules.git//rds"
  project_name = local.project_name
  environment = local.environment
  private_data_subnet_az1_id = module.vpc.private_data_subnet_az1_id
  private_data_subnet_az2_id = module.vpc.private_data_subnet_az2_id
  database_identifier = var.database_identifier
  database_engine = var.database_engine
  engine_version = var.engine_version
  database_instance_class = var.database_instance_class
  database_security_group_id = module.security_group.database_security_group_id
  db_master_username = var.db_master_username
  db_master_password = var.db_master_password
  database_name = var.database_name
  parameter_groupname = var.parameter_groupname
}

# request ssl certificate
module "ssl_certificate" {
  source = "git@github.com:Silas-cloudspace/terraform-modules.git//acm"
  project_name = local.project_name
  environment = local.environment
  domain_name = var.domain_name
  alternative_names = var.alternative_names
}