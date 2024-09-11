# vpc variables
region                       = "eu-west-2"
project_name                 = "rentzone"
environment                  = "dev"
vpc_cidr                     = "10.0.0.0/16"
public_subnet_az1_cidr       = "10.0.0.0/24"
public_subnet_az2_cidr       = "10.1.0.0/24"
private_app_subnet_az1_cidr  = "10.2.0.0/24"
private_app_subnet_az2_cidr  = "10.3.0.0/24"
private_data_subnet_az1_cidr = "10.4.0.0/24"
private_data_subnet_az2_cidr = "10.5.0.0/24"

# Security group variables
ssh_ip = "2.120.140.109/32" # your IP

# RDS variables
database_identifier = "dev-rds-db"
database_engine = "mysql"
engine_version = "8.0.36"
database_instance_class = "db.t3.medium"
db_master_username = "admin1982"
db_master_password = "nimda1982"
database_name = "applicationdb"
parameter_groupname = "dev-para-group"

# acm variables
domain_name = "cloudspace-consulting.com"
alternative_names = "*.cloudspace-consulting.com"