module "label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  enabled    = var.enabled
  namespace  = var.namespace
  name       = var.name
  stage      = var.stage
  delimiter  = var.delimiter
  attributes = var.attributes
  tags       = var.tags
}

module "label_emr" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  enabled    = var.enabled
  context    = module.label.context
  attributes = compact(concat(module.label.attributes, list("emr")))
}

module "label_ec2" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  enabled    = var.enabled
  context    = module.label.context
  attributes = compact(concat(module.label.attributes, list("ec2")))
}

module "label_master" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  enabled    = var.enabled
  context    = module.label.context
  attributes = compact(concat(module.label.attributes, list("master")))
}

module "label_slave" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  enabled    = var.enabled
  context    = module.label.context
  attributes = compact(concat(module.label.attributes, list("slave")))
}

module "label_master_managed" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  enabled    = var.enabled
  context    = module.label.context
  attributes = compact(concat(module.label.attributes, list("master", "managed")))
}

module "label_slave_managed" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  enabled    = var.enabled
  context    = module.label.context
  attributes = compact(concat(module.label.attributes, list("slave", "managed")))
}

module "label_service_managed" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  enabled    = var.enabled
  context    = module.label.context
  attributes = compact(concat(module.label.attributes, list("service", "managed")))
}

data "aws_subnet" "default" {
  id = var.subnet_id
}

/*
NOTE on EMR-Managed security groups: These security groups will have any missing inbound or outbound access rules added and maintained by AWS,
to ensure proper communication between instances in a cluster. The EMR service will maintain these rules for groups provided
in emr_managed_master_security_group and emr_managed_slave_security_group;
attempts to remove the required rules may succeed, only for the EMR service to re-add them in a matter of minutes.
This may cause Terraform to fail to destroy an environment that contains an EMR cluster, because the EMR service does not revoke rules added on deletion,
leaving a cyclic dependency between the security groups that prevents their deletion.
To avoid this, use the revoke_rules_on_delete optional attribute for any Security Group used in
emr_managed_master_security_group and emr_managed_slave_security_group.
*/

# https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-sg-specify.html
# https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-man-sec-groups.html
# https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-clusters-in-a-vpc.html

resource "aws_security_group" "managed_master" {
  count                  = var.enabled ? 1 : 0
  revoke_rules_on_delete = true
  vpc_id                 = var.vpc_id
  name                   = module.label_master_managed.id
  description            = "EmrManagedMasterSecurityGroup"
  tags                   = module.label_master_managed.tags

  # EMR will update "ingress" and "egress" so we ignore the changes here
  lifecycle {
    ignore_changes = ["ingress", "egress"]
  }
}

resource "aws_security_group_rule" "managed_master_egress" {
  count             = var.enabled ? 1 : 0
  description       = "Allow all egress traffic"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = join("", aws_security_group.managed_master.*.id)
}

resource "aws_security_group" "managed_slave" {
  count                  = var.enabled ? 1 : 0
  revoke_rules_on_delete = true
  vpc_id                 = var.vpc_id
  name                   = module.label_slave_managed.id
  description            = "EmrManagedSlaveSecurityGroup"
  tags                   = module.label_slave_managed.tags

  # EMR will update "ingress" and "egress" so we ignore the changes here
  lifecycle {
    ignore_changes = ["ingress", "egress"]
  }
}

resource "aws_security_group_rule" "managed_slave_egress" {
  count             = var.enabled ? 1 : 0
  description       = "Allow all egress traffic"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = join("", aws_security_group.managed_slave.*.id)
}

resource "aws_security_group" "managed_service_access" {
  count                  = var.enabled && var.subnet_type == "private" ? 1 : 0
  revoke_rules_on_delete = true
  vpc_id                 = var.vpc_id
  name                   = module.label_service_managed.id
  description            = "EmrManagedServiceAccessSecurityGroup"
  tags                   = module.label_service_managed.tags

  # EMR will update "ingress" and "egress" so we ignore the changes here
  lifecycle {
    ignore_changes = ["ingress", "egress"]
  }
}

resource "aws_security_group_rule" "managed_service_access_egress" {
  count             = var.enabled && var.subnet_type == "private" ? 1 : 0
  description       = "Allow all egress traffic"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = join("", aws_security_group.managed_service_access.*.id)
}

# Specify additional master and slave security groups
resource "aws_security_group" "master" {
  count                  = var.enabled ? 1 : 0
  revoke_rules_on_delete = true
  vpc_id                 = var.vpc_id
  name                   = module.label_master.id
  description            = "Allow inbound traffic from Security Groups and CIDRs for masters. Allow all outbound traffic"
  tags                   = module.label_master.tags
}

resource "aws_security_group_rule" "master_ingress_security_groups" {
  count                    = var.enabled ? length(var.master_allowed_security_groups) : 0
  description              = "Allow inbound traffic from Security Groups"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = var.master_allowed_security_groups[count.index]
  security_group_id        = join("", aws_security_group.master.*.id)
}

resource "aws_security_group_rule" "master_ingress_cidr_blocks" {
  count             = var.enabled && length(var.master_allowed_cidr_blocks) > 0 ? 1 : 0
  description       = "Allow inbound traffic from CIDR blocks"
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = var.master_allowed_cidr_blocks
  security_group_id = join("", aws_security_group.master.*.id)
}

resource "aws_security_group_rule" "master_egress" {
  count             = var.enabled ? 1 : 0
  description       = "Allow all egress traffic"
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = join("", aws_security_group.master.*.id)
}

resource "aws_security_group" "slave" {
  count                  = var.enabled ? 1 : 0
  revoke_rules_on_delete = true
  vpc_id                 = var.vpc_id
  name                   = module.label_slave.id
  description            = "Allow inbound traffic from Security Groups and CIDRs for slaves. Allow all outbound traffic"
  tags                   = module.label_slave.tags
}

resource "aws_security_group_rule" "slave_ingress_security_groups" {
  count                    = var.enabled ? length(var.slave_allowed_security_groups) : 0
  description              = "Allow inbound traffic from Security Groups"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = var.slave_allowed_security_groups[count.index]
  security_group_id        = join("", aws_security_group.slave.*.id)
}

resource "aws_security_group_rule" "slave_ingress_cidr_blocks" {
  count             = var.enabled && length(var.slave_allowed_cidr_blocks) > 0 ? 1 : 0
  description       = "Allow inbound traffic from CIDR blocks"
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = var.slave_allowed_cidr_blocks
  security_group_id = join("", aws_security_group.slave.*.id)
}

resource "aws_security_group_rule" "slave_egress" {
  count             = var.enabled ? 1 : 0
  description       = "Allow all egress traffic"
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = join("", aws_security_group.slave.*.id)
}

/*
Allows Amazon EMR to call other AWS services on your behalf when provisioning resources and performing service-level actions.
This role is required for all clusters.
https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-iam-roles.html
*/
data "aws_iam_policy_document" "assume_role_emr" {
  count = var.enabled ? 1 : 0

  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["elasticmapreduce.amazonaws.com", "application-autoscaling.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "emr" {
  count              = var.enabled ? 1 : 0
  name               = module.label_emr.id
  assume_role_policy = join("", data.aws_iam_policy_document.assume_role_emr.*.json)
}

# https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-iam-roles.html
resource "aws_iam_role_policy_attachment" "emr" {
  count      = var.enabled ? 1 : 0
  role       = join("", aws_iam_role.emr.*.name)
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceRole"
}

/*
Application processes that run on top of the Hadoop ecosystem on cluster instances use this role when they call other AWS services.
For accessing data in Amazon S3 using EMRFS, you can specify different roles to be assumed based on the user or group making the request,
or on the location of data in Amazon S3.
This role is required for all clusters.
https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-iam-roles.html
*/
data "aws_iam_policy_document" "assume_role_ec2" {
  count = var.enabled ? 1 : 0

  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ec2" {
  count              = var.enabled ? 1 : 0
  name               = module.label_ec2.id
  assume_role_policy = join("", data.aws_iam_policy_document.assume_role_ec2.*.json)
}

# https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-iam-roles.html
resource "aws_iam_role_policy_attachment" "ec2" {
  count      = var.enabled ? 1 : 0
  role       = join("", aws_iam_role.ec2.*.name)
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceforEC2Role"
}

module "kms_key" {
  source              = "git::https://github.com/cloudposse/terraform-aws-kms-key.git?ref=tags/0.3.0"
  name                = var.name
  stage               = var.stage
  delimiter           = var.delimiter
  attributes          = var.attributes
  tags                = var.tags
  enable_key_rotation = true
  alias               = format("alias/%s", module.label.id)
}

module "s3_bucket" {
  source             = "git::https://github.com/cloudposse/terraform-aws-s3-bucket.git?ref=tags/0.6.0"
  enabled            = var.enabled
  user_enabled       = false
  versioning_enabled = true
  namespace          = var.namespace
  name               = var.name
  stage              = var.stage
  delimiter          = var.delimiter
  attributes         = var.attributes
  tags               = var.tags
  sse_algorithm      = "aws:kms"
  kms_master_key_arn = module.kms_key.alias_arn
  force_destroy      = var.s3_bucket_force_destroy
}

locals {
  bootstrap_enabled = var.enabled && length(var.bootstrap_action) > 0
  bootstrap_data = jsonencode(
    [for action in var.bootstrap_action :
      {
        name       = action.name
        scriptPath = action.path
        args       = action.args
      }
    ]
  )
  bootstrap_file              = "bootstrap-actions.json"
  configurations_enabled      = var.enabled && (var.configurations_json != "" && var.configurations_json != null)
  configurations_file         = "configurations.json"
  task_instance_group_enabled = var.enabled && var.create_task_instance_group
}

resource "aws_s3_bucket_object" "bootstrap" {
  count   = local.bootstrap_enabled ? 1 : 0
  bucket  = module.s3_bucket.bucket_id
  key     = local.bootstrap_file
  content = local.bootstrap_data
  etag    = md5(local.bootstrap_data)
}

resource "aws_s3_bucket_object" "configurations" {
  count   = local.configurations_enabled ? 1 : 0
  bucket  = module.s3_bucket.bucket_id
  key     = local.configurations_file
  content = var.configurations_json
  etag    = local.configurations_enabled ? md5(var.configurations_json) : ""
}

resource "spotinst_mrscaler_aws" "default" {
  count         = var.enabled ? 1 : 0
  name          = module.label.id
  region        = var.region
  strategy      = "new"
  release_label = var.release_label

  expose_cluster_id = true

  availability_zones = [join("", formatlist("%s:%s", data.aws_subnet.default.*.availability_zone, data.aws_subnet.default.*.id))]

  provisioning_timeout {
    timeout        = var.provisioning_timeout
    timeout_action = var.provisioning_timeout_action
  }

  // --- CLUSTER ------------
  log_uri         = var.log_uri
  additional_info = var.additional_info
  job_flow_role   = join("", aws_iam_role.ec2.*.name)
  security_config = var.security_configuration
  service_role    = join("", aws_iam_role.emr.*.arn)

  termination_protected = var.termination_protection
  keep_job_flow_alive   = var.keep_job_flow_alive_when_no_steps
  // -------------------------

  // --- OPTONAL COMPUTE -----
  custom_ami_id        = var.custom_ami_id
  repo_upgrade_on_boot = var.repo_upgrade_on_boot
  ec2_key_name         = var.key_name

  managed_primary_security_group     = join("", aws_security_group.managed_master.*.id)
  managed_replica_security_group     = join("", aws_security_group.managed_slave.*.id)
  service_access_security_group      = var.subnet_type == "private" ? join("", aws_security_group.managed_service_access.*.id) : null
  additional_primary_security_groups = [join("", aws_security_group.master.*.id)]
  additional_replica_security_groups = [join("", aws_security_group.slave.*.id)]

  dynamic "applications" {
    for_each = var.applications
    content {
      name = applications.value
    }
  }

  dynamic "instance_weights" {
    for_each = var.instance_weights
    content {
      instance_type     = instance_weights.value.instance_type
      weighted_capacity = instance_weights.value.weighted_capacity
    }
  }

  dynamic "configurations_file" {
    for_each = toset(compact([local.configurations_enabled ? local.configurations_file : ""]))
    content {
      bucket = join("", module.s3_bucket.*.bucket_id)
      key    = configurations_file.value
    }
  }

  dynamic "bootstrap_actions_file" {
    for_each = toset(compact([local.bootstrap_enabled ? local.bootstrap_file : ""]))
    content {
      bucket = join("", module.s3_bucket.*.bucket_id)
      key    = bootstrap_actions_file.value
    }
  }

  // --- MASTER GROUP -------------
  master_instance_types = var.master_instance_group_instance_types
  master_lifecycle      = var.master_instance_group_lifecycle
  master_ebs_optimized  = true

  master_ebs_block_device {
    volumes_per_instance = var.master_instance_group_ebs_volumes_per_instance
    volume_type          = var.master_instance_group_ebs_type
    iops                 = var.master_instance_group_ebs_iops
    size_in_gb           = var.master_instance_group_ebs_size
  }

  // --- CORE GROUP -------------
  core_instance_types   = var.core_instance_group_instance_types
  core_min_size         = var.core_instance_group_instance_min_size
  core_max_size         = var.core_instance_group_instance_max_size
  core_desired_capacity = var.core_instance_group_instance_desired_size
  core_lifecycle        = var.core_instance_group_lifecycle
  core_ebs_optimized    = true

  core_ebs_block_device {
    size_in_gb           = var.core_instance_group_ebs_size
    volume_type          = var.core_instance_group_ebs_type
    iops                 = var.core_instance_group_ebs_iops
    volumes_per_instance = var.core_instance_group_ebs_volumes_per_instance
  }
  // ----------------------------

  // --- TASK GROUP -------------
  task_instance_types   = var.task_instance_group_instance_types
  task_min_size         = local.task_instance_group_enabled ? var.task_instance_group_instance_min_size : 0
  task_max_size         = local.task_instance_group_enabled ? var.task_instance_group_instance_max_size : 0
  task_desired_capacity = local.task_instance_group_enabled ? var.task_instance_group_instance_desired_size : 0
  task_lifecycle        = var.task_instance_group_lifecycle
  task_ebs_optimized    = var.task_instance_group_ebs_optimized

  task_ebs_block_device {
    size_in_gb           = var.task_instance_group_ebs_size
    volume_type          = var.task_instance_group_ebs_type
    iops                 = var.task_instance_group_ebs_iops
    volumes_per_instance = var.task_instance_group_ebs_volumes_per_instance
  }

  // --- TAGS -------------------
  dynamic "tags" {
    for_each = toset(module.label.tags_as_list_of_maps)
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

data "aws_vpc_endpoint_service" "s3" {
  count = var.enabled && var.subnet_type == "private" ? 1 : 0
  service = "s3"
}

data "aws_vpc_endpoint" "s3" {
  count = var.enabled && var.subnet_type == "private" && length(data.aws_vpc_endpoint_service.s3.*.service_name) > 0 ? 1 : 0
  vpc_id       = var.vpc_id
  service_name = join("", data.aws_vpc_endpoint_service.s3.*.service_name)
}


# https://www.terraform.io/docs/providers/aws/r/vpc_endpoint.html
# https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-clusters-in-a-vpc.html
resource "aws_vpc_endpoint" "vpc_endpoint_s3" {
  count           = var.enabled && var.subnet_type == "private" && length(data.aws_vpc_endpoint.s3.*.id) > 0 ? 1 : 0
  vpc_id          = var.vpc_id
  service_name    = join("", data.aws_vpc_endpoint_service.s3.*.service_name)
  auto_accept     = true
  route_table_ids = [var.route_table_id]
  tags            = module.label.tags
}
