provider "aws" {
  region = var.region
}

module "vpc" {
  source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=tags/0.8.1"
  namespace  = var.namespace
  stage      = var.stage
  name       = var.name
  cidr_block = var.vpc_cidr_block
}

module "subnets" {
  source               = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=tags/0.18.1"
  availability_zones   = var.availability_zones
  namespace            = var.namespace
  stage                = var.stage
  name                 = var.name
  vpc_id               = module.vpc.vpc_id
  igw_id               = module.vpc.igw_id
  cidr_block           = module.vpc.vpc_cidr_block
  nat_gateway_enabled  = false
  nat_instance_enabled = false
}

module "s3_log_storage" {
  source        = "git::https://github.com/cloudposse/terraform-aws-s3-log-storage.git?ref=tags/0.6.0"
  region        = var.region
  namespace     = var.namespace
  stage         = var.stage
  name          = var.name
  attributes    = ["logs"]
  force_destroy = true
}

module "aws_key_pair" {
  source              = "git::https://github.com/cloudposse/terraform-aws-key-pair.git?ref=tags/0.4.0"
  namespace           = var.namespace
  stage               = var.stage
  name                = var.name
  attributes          = ["ssh", "key"]
  ssh_public_key_path = var.ssh_public_key_path
  generate_ssh_key    = var.generate_ssh_key
}

module "spotinst_mrscaler" {
  source     = "../../"
  namespace  = var.namespace
  stage      = var.stage
  name       = var.name
  delimiter  = var.delimiter
  attributes = var.attributes
  tags       = var.tags

  region         = var.region
  vpc_id         = module.vpc.vpc_id
  subnet_id      = module.subnets.private_subnet_ids[0]
  route_table_id = module.subnets.private_route_table_ids[0]
  subnet_type    = "private"

  core_instance_group_instance_types           = var.core_instance_group_instance_types
  core_instance_group_instance_min_size        = var.core_instance_group_instance_min_size
  core_instance_group_instance_max_size        = var.core_instance_group_instance_max_size
  core_instance_group_lifecycle                = var.core_instance_group_lifecycle
  core_instance_group_ebs_iops                 = var.core_instance_group_ebs_iops
  core_instance_group_ebs_size                 = var.core_instance_group_ebs_size
  core_instance_group_ebs_type                 = var.core_instance_group_ebs_type
  core_instance_group_ebs_volumes_per_instance = var.core_instance_group_ebs_volumes_per_instance

  master_instance_group_instance_types           = var.master_instance_group_instance_types
  master_instance_group_lifecycle                = var.master_instance_group_lifecycle
  master_instance_group_ebs_iops                 = var.master_instance_group_ebs_iops
  master_instance_group_ebs_size                 = var.master_instance_group_ebs_size
  master_instance_group_ebs_type                 = var.master_instance_group_ebs_type
  master_instance_group_ebs_volumes_per_instance = var.master_instance_group_ebs_volumes_per_instance

  task_instance_group_instance_types           = var.task_instance_group_instance_types
  task_instance_group_ebs_iops                 = var.task_instance_group_ebs_iops
  task_instance_group_instance_min_size        = var.task_instance_group_instance_min_size
  task_instance_group_instance_max_size        = var.task_instance_group_instance_max_size
  task_instance_group_instance_desired_size    = var.task_instance_group_instance_desired_size
  task_instance_group_lifecycle                = var.task_instance_group_lifecycle
  task_instance_group_ebs_size                 = var.task_instance_group_ebs_size
  task_instance_group_ebs_optimized            = var.task_instance_group_ebs_optimized
  task_instance_group_ebs_type                 = var.task_instance_group_ebs_type
  task_instance_group_ebs_volumes_per_instance = var.task_instance_group_ebs_volumes_per_instance

  instance_weights                  = var.instance_weights
  master_allowed_security_groups    = [module.vpc.vpc_default_security_group_id]
  slave_allowed_security_groups     = [module.vpc.vpc_default_security_group_id]
  release_label                     = var.release_label
  applications                      = var.applications
  configurations_json               = var.configurations_json
  create_task_instance_group        = var.create_task_instance_group
  log_uri                           = format("s3://%s", module.s3_log_storage.bucket_id)
  key_name                          = module.aws_key_pair.key_name
  s3_bucket_force_destroy           = true
  provisioning_timeout              = var.provisioning_timeout
  provisioning_timeout_action       = var.provisioning_timeout_action
  repo_upgrade_on_boot              = var.repo_upgrade_on_boot
  termination_protection            = var.termination_protection
  keep_job_flow_alive_when_no_steps = var.keep_job_flow_alive_when_no_steps
  custom_ami_id                     = var.custom_ami_id
  additional_info                   = var.additional_info
  security_configuration            = var.security_configuration
  bootstrap_action                  = var.bootstrap_action
}
