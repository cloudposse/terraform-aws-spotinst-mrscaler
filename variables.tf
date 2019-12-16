variable "enabled" {
  type        = bool
  description = "Set to false to prevent the module from creating any resources"
  default     = true
}

variable "namespace" {
  type        = string
  description = "Namespace (e.g. `eg` or `cp`)"
  default     = ""
}

variable "stage" {
  type        = string
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
  default     = ""
}

variable "name" {
  type        = string
  description = "Name of the application"
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter between `namespace`, `stage`, `name` and `attributes`"
}

variable "attributes" {
  type        = list(string)
  description = "Additional attributes (_e.g._ \"1\")"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Additional tags (_e.g._ { BusinessUnit : ABC })"
  default     = {}
}

variable "provisioning_timeout" {
  type        = number
  description = "The amount of time (minutes) after which the cluster perform provisioning_timeout_action if it's still in provisioning status."
  default     = 15
}

variable "provisioning_timeout_action" {
  type        = string
  description = "The action to take if the timeout is exceeded. Valid values: `terminate`, `terminateAndRetry`"
  default     = "terminate"
}

variable "repo_upgrade_on_boot" {
  type        = string
  description = "Specifies the type of updates that are applied from the Amazon Linux AMI package repositories when an instance boots using the AMI. Possible values include: `SECURITY`, `NONE`"
  default     = "NONE"
}

variable "master_allowed_security_groups" {
  type        = list(string)
  default     = []
  description = "List of security groups to be allowed to connect to the master instances"
}

variable "slave_allowed_security_groups" {
  type        = list(string)
  default     = []
  description = "List of security groups to be allowed to connect to the slave instances"
}

variable "master_allowed_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "List of CIDR blocks to be allowed to access the master instances"
}

variable "slave_allowed_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "List of CIDR blocks to be allowed to access the slave instances"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID to create the cluster in (e.g. `vpc-a22222ee`)"
}

variable "termination_protection" {
  type        = bool
  description = "Switch on/off termination protection (default is false, except when using multiple master nodes). Before attempting to destroy the resource when termination protection is enabled, this configuration must be applied with its value set to false"
  default     = false
}

variable "keep_job_flow_alive_when_no_steps" {
  type        = bool
  description = "Switch on/off run cluster with no steps or when all steps are complete"
  default     = true
}

variable "custom_ami_id" {
  type        = string
  description = "A custom Amazon Linux AMI for the cluster (instead of an EMR-owned AMI). Available in Amazon EMR version 5.7.0 and later"
  default     = null
}

variable "release_label" {
  type        = string
  description = "The release label for the Amazon EMR release. https://docs.aws.amazon.com/emr/latest/ReleaseGuide/emr-release-5x.html"
  default     = "emr-5.25.0"
}

variable "applications" {
  type        = list(string)
  description = "A list of applications for the cluster. Valid values are: Flink, Ganglia, Hadoop, HBase, HCatalog, Hive, Hue, JupyterHub, Livy, Mahout, MXNet, Oozie, Phoenix, Pig, Presto, Spark, Sqoop, TensorFlow, Tez, Zeppelin, and ZooKeeper (as of EMR 5.25.0). Case insensitive"
}

variable "instance_weights" {
  type = list(object({
    instance_type     = string
    weighted_capacity = number
  }))
  default     = []
  description = "Describes the instance and weights. Check out [Elastigroup Weighted Instances](https://api.spotinst.com/elastigroup-for-aws/concepts/general-concepts/elastigroup-capacity-instances-or-weighted) for more info."
}

# https://docs.aws.amazon.com/emr/latest/ReleaseGuide/emr-configure-apps.html
variable "configurations_json" {
  type        = string
  description = "A JSON string for supplying list of configurations for the EMR cluster. See https://docs.aws.amazon.com/emr/latest/ReleaseGuide/emr-configure-apps.html for more details"
  default     = null
}

variable "key_name" {
  type        = string
  description = "Amazon EC2 key pair that can be used to ssh to the master node as the user called `hadoop`"
  default     = null
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "subnet_id" {
  type        = string
  description = "VPC subnet ID where you want the job flow to launch. Cannot specify the `cc1.4xlarge` instance type for nodes of a job flow launched in a Amazon VPC"
}

variable "subnet_type" {
  type        = string
  description = "Type of VPC subnet ID where you want the job flow to launch. Supported values are `private` or `public`"
  default     = "private"
}

variable "route_table_id" {
  type        = string
  description = "Route table ID for the VPC S3 Endpoint when launching the EMR cluster in a private subnet. Required when `subnet_type` is `private`"
  default     = ""
}

variable "log_uri" {
  type        = string
  description = "The path to the Amazon S3 location where logs for this cluster are stored"
  default     = null
}

variable "core_instance_group_instance_types" {
  type        = list(string)
  description = "EC2 instance type for all instances in the Core instance group"
  default     = ["c4.2xlarge", "c4.large", "c4.4xlarge", "c4.8xlarge", "c4.xlarge", "c5.9xlarge", "c5.large", "c5.metal", "c5.2xlarge", "c5.4xlarge", "c5.xlarge", "c5.24xlarge", "c5.12xlarge", "c5.18xlarge", "c5d.4xlarge", "c5d.large", "c5d.18xlarge", "c5d.9xlarge", "c5d.xlarge", "c5d.2xlarge", "d2.4xlarge", "d2.xlarge", "d2.2xlarge", "d2.8xlarge", "g3.16xlarge", "g3.8xlarge", "g3.4xlarge", "g3s.xlarge", "g4dn.12xlarge", "g4dn.16xlarge", "g4dn.2xlarge", "g4dn.4xlarge", "g4dn.8xlarge", "g4dn.xlarge", "i3.large", "i3.16xlarge", "i3.xlarge", "i3.4xlarge", "i3.8xlarge", "i3.2xlarge", "i3en.12xlarge", "i3en.24xlarge", "i3en.2xlarge", "i3en.3xlarge", "i3en.6xlarge", "i3en.large", "i3en.xlarge", "m4.large", "m4.xlarge", "m4.16xlarge", "m4.2xlarge", "m4.4xlarge", "m4.10xlarge", "m5.large", "m5.16xlarge", "m5.12xlarge", "m5.24xlarge", "m5.2xlarge", "m5.4xlarge", "m5.xlarge", "m5.8xlarge", "m5.metal", "m5a.12xlarge", "m5a.16xlarge", "m5a.24xlarge", "m5a.2xlarge", "m5a.4xlarge", "m5a.8xlarge", "m5a.large", "m5a.xlarge", "m5ad.12xlarge", "m5ad.24xlarge", "m5ad.2xlarge", "m5ad.4xlarge", "m5ad.large", "m5ad.xlarge", "m5d.8xlarge", "m5d.16xlarge", "m5d.xlarge", "m5d.4xlarge", "m5d.12xlarge", "m5d.24xlarge", "m5d.2xlarge", "m5d.large", "m5d.metal", "p3.16xlarge", "p3.8xlarge", "p3.2xlarge", "r4.xlarge", "r4.16xlarge", "r4.large", "r4.4xlarge", "r4.8xlarge", "r4.2xlarge", "r5.8xlarge", "r5.metal", "r5.24xlarge", "r5.2xlarge", "r5.large", "r5.4xlarge", "r5.16xlarge", "r5.12xlarge", "r5.xlarge", "r5a.12xlarge", "r5a.16xlarge", "r5a.24xlarge", "r5a.2xlarge", "r5a.4xlarge", "r5a.8xlarge", "r5a.large", "r5a.xlarge", "r5ad.12xlarge", "r5ad.24xlarge", "r5ad.2xlarge", "r5ad.4xlarge", "r5ad.large", "r5ad.xlarge", "r5d.4xlarge", "r5d.8xlarge", "r5d.12xlarge", "r5d.xlarge", "r5d.16xlarge", "r5d.24xlarge", "r5d.metal", "r5d.2xlarge", "r5d.large", "t2.xlarge", "t2.large", "t2.small", "t2.medium", "t2.2xlarge", "t2.micro", "t3.xlarge", "t3.large", "t3.small", "t3.medium", "t3.micro", "t3.2xlarge", "t3a.xlarge", "t3a.2xlarge", "t3a.large", "t3a.medium", "t3a.small", "t3a.micro", "z1d.6xlarge", "z1d.3xlarge", "z1d.12xlarge", "z1d.large", "z1d.2xlarge", "z1d.xlarge"]
}

variable "core_instance_group_instance_min_size" {
  type        = number
  description = "Min number of instances for the Core instance group. Must be at least 1"
  default     = 1
}

variable "core_instance_group_instance_max_size" {
  type        = number
  description = "Max number of instances for the Core instance group. Must be greater or equal to `core_instance_group_instance_min_size`"
  default     = 1
}

variable "core_instance_group_instance_desired_size" {
  type        = number
  description = "Desired number of instances for the Core instance group. Must between of `core_instance_group_instance_min_size` and `core_instance_group_instance_max_size`"
  default     = 1
}

variable "core_instance_group_lifecycle" {
  type        = string
  default     = "SPOT"
  description = "The MrScaler lifecycle for instances in core group. Allowed values are `SPOT` and `ON_DEMAND`"
}

variable "core_instance_group_ebs_size" {
  type        = number
  description = "Core instances volume size, in gibibytes (GiB)"
}

variable "core_instance_group_ebs_type" {
  type        = string
  description = "Core instances volume type. Valid options are `gp2`, `io1`, `standard` and `st1`"
  default     = "gp2"
}

variable "core_instance_group_ebs_iops" {
  type        = number
  description = "The number of I/O operations per second (IOPS) that the Core volume supports"
  default     = null
}

variable "core_instance_group_ebs_volumes_per_instance" {
  type        = number
  description = "The number of EBS volumes with this configuration to attach to each EC2 instance in the Core instance group"
  default     = 1
}

variable "master_instance_group_instance_types" {
  type        = list(string)
  description = "EC2 instance types for all instances in the Master instance group"
  default     = ["c4.2xlarge", "c4.large", "c4.4xlarge", "c4.8xlarge", "c4.xlarge", "c5.9xlarge", "c5.large", "c5.metal", "c5.2xlarge", "c5.4xlarge", "c5.xlarge", "c5.24xlarge", "c5.12xlarge", "c5.18xlarge", "c5d.4xlarge", "c5d.large", "c5d.18xlarge", "c5d.9xlarge", "c5d.xlarge", "c5d.2xlarge", "d2.4xlarge", "d2.xlarge", "d2.2xlarge", "d2.8xlarge", "g3.16xlarge", "g3.8xlarge", "g3.4xlarge", "g3s.xlarge", "g4dn.12xlarge", "g4dn.16xlarge", "g4dn.2xlarge", "g4dn.4xlarge", "g4dn.8xlarge", "g4dn.xlarge", "i3.large", "i3.16xlarge", "i3.xlarge", "i3.4xlarge", "i3.8xlarge", "i3.2xlarge", "i3en.12xlarge", "i3en.24xlarge", "i3en.2xlarge", "i3en.3xlarge", "i3en.6xlarge", "i3en.large", "i3en.xlarge", "m4.large", "m4.xlarge", "m4.16xlarge", "m4.2xlarge", "m4.4xlarge", "m4.10xlarge", "m5.large", "m5.16xlarge", "m5.12xlarge", "m5.24xlarge", "m5.2xlarge", "m5.4xlarge", "m5.xlarge", "m5.8xlarge", "m5.metal", "m5a.12xlarge", "m5a.16xlarge", "m5a.24xlarge", "m5a.2xlarge", "m5a.4xlarge", "m5a.8xlarge", "m5a.large", "m5a.xlarge", "m5ad.12xlarge", "m5ad.24xlarge", "m5ad.2xlarge", "m5ad.4xlarge", "m5ad.large", "m5ad.xlarge", "m5d.8xlarge", "m5d.16xlarge", "m5d.xlarge", "m5d.4xlarge", "m5d.12xlarge", "m5d.24xlarge", "m5d.2xlarge", "m5d.large", "m5d.metal", "p3.16xlarge", "p3.8xlarge", "p3.2xlarge", "r4.xlarge", "r4.16xlarge", "r4.large", "r4.4xlarge", "r4.8xlarge", "r4.2xlarge", "r5.8xlarge", "r5.metal", "r5.24xlarge", "r5.2xlarge", "r5.large", "r5.4xlarge", "r5.16xlarge", "r5.12xlarge", "r5.xlarge", "r5a.12xlarge", "r5a.16xlarge", "r5a.24xlarge", "r5a.2xlarge", "r5a.4xlarge", "r5a.8xlarge", "r5a.large", "r5a.xlarge", "r5ad.12xlarge", "r5ad.24xlarge", "r5ad.2xlarge", "r5ad.4xlarge", "r5ad.large", "r5ad.xlarge", "r5d.4xlarge", "r5d.8xlarge", "r5d.12xlarge", "r5d.xlarge", "r5d.16xlarge", "r5d.24xlarge", "r5d.metal", "r5d.2xlarge", "r5d.large", "t2.xlarge", "t2.large", "t2.small", "t2.medium", "t2.2xlarge", "t2.micro", "t3.xlarge", "t3.large", "t3.small", "t3.medium", "t3.micro", "t3.2xlarge", "t3a.xlarge", "t3a.2xlarge", "t3a.large", "t3a.medium", "t3a.small", "t3a.micro", "z1d.6xlarge", "z1d.3xlarge", "z1d.12xlarge", "z1d.large", "z1d.2xlarge", "z1d.xlarge"]
}

variable "master_instance_group_lifecycle" {
  type        = string
  default     = "SPOT"
  description = "The MrScaler lifecycle for instances in master group. Allowed values are `SPOT` and `ON_DEMAND`"
}

variable "master_instance_group_ebs_size" {
  type        = number
  description = "Master instances volume size, in gibibytes (GiB)"
}

variable "master_instance_group_ebs_type" {
  type        = string
  description = "Master instances volume type. Valid options are `gp2`, `io1`, `standard` and `st1`"
  default     = "gp2"
}

variable "master_instance_group_ebs_iops" {
  type        = number
  description = "The number of I/O operations per second (IOPS) that the Master volume supports"
  default     = null
}

variable "master_instance_group_ebs_volumes_per_instance" {
  type        = number
  description = "The number of EBS volumes with this configuration to attach to each EC2 instance in the Master instance group"
  default     = 1
}

variable "additional_info" {
  type        = string
  description = "A JSON string for selecting additional features such as adding proxy information. Note: Currently there is no API to retrieve the value of this argument after EMR cluster creation from provider, therefore Terraform cannot detect drift from the actual EMR cluster if its value is changed outside Terraform"
  default     = null
}

variable "security_configuration" {
  type        = string
  description = "The security configuration name to attach to the EMR cluster. Only valid for EMR clusters with `release_label` 4.8.0 or greater. See https://www.terraform.io/docs/providers/aws/r/emr_security_configuration.html for more info"
  default     = null
}

variable "create_task_instance_group" {
  type        = bool
  description = "Whether to create an instance group for Task nodes. For more info: https://www.terraform.io/docs/providers/aws/r/emr_instance_group.html, https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-master-core-task-nodes.html"
  default     = false
}

variable "task_instance_group_instance_types" {
  type        = list(string)
  description = "EC2 instance types for all instances in the Task instance group"
  default     = ["c4.2xlarge", "c4.large", "c4.4xlarge", "c4.8xlarge", "c4.xlarge", "c5.9xlarge", "c5.large", "c5.metal", "c5.2xlarge", "c5.4xlarge", "c5.xlarge", "c5.24xlarge", "c5.12xlarge", "c5.18xlarge", "c5d.4xlarge", "c5d.large", "c5d.18xlarge", "c5d.9xlarge", "c5d.xlarge", "c5d.2xlarge", "d2.4xlarge", "d2.xlarge", "d2.2xlarge", "d2.8xlarge", "g3.16xlarge", "g3.8xlarge", "g3.4xlarge", "g3s.xlarge", "g4dn.12xlarge", "g4dn.16xlarge", "g4dn.2xlarge", "g4dn.4xlarge", "g4dn.8xlarge", "g4dn.xlarge", "i3.large", "i3.16xlarge", "i3.xlarge", "i3.4xlarge", "i3.8xlarge", "i3.2xlarge", "i3en.12xlarge", "i3en.24xlarge", "i3en.2xlarge", "i3en.3xlarge", "i3en.6xlarge", "i3en.large", "i3en.xlarge", "m4.large", "m4.xlarge", "m4.16xlarge", "m4.2xlarge", "m4.4xlarge", "m4.10xlarge", "m5.large", "m5.16xlarge", "m5.12xlarge", "m5.24xlarge", "m5.2xlarge", "m5.4xlarge", "m5.xlarge", "m5.8xlarge", "m5.metal", "m5a.12xlarge", "m5a.16xlarge", "m5a.24xlarge", "m5a.2xlarge", "m5a.4xlarge", "m5a.8xlarge", "m5a.large", "m5a.xlarge", "m5ad.12xlarge", "m5ad.24xlarge", "m5ad.2xlarge", "m5ad.4xlarge", "m5ad.large", "m5ad.xlarge", "m5d.8xlarge", "m5d.16xlarge", "m5d.xlarge", "m5d.4xlarge", "m5d.12xlarge", "m5d.24xlarge", "m5d.2xlarge", "m5d.large", "m5d.metal", "p3.16xlarge", "p3.8xlarge", "p3.2xlarge", "r4.xlarge", "r4.16xlarge", "r4.large", "r4.4xlarge", "r4.8xlarge", "r4.2xlarge", "r5.8xlarge", "r5.metal", "r5.24xlarge", "r5.2xlarge", "r5.large", "r5.4xlarge", "r5.16xlarge", "r5.12xlarge", "r5.xlarge", "r5a.12xlarge", "r5a.16xlarge", "r5a.24xlarge", "r5a.2xlarge", "r5a.4xlarge", "r5a.8xlarge", "r5a.large", "r5a.xlarge", "r5ad.12xlarge", "r5ad.24xlarge", "r5ad.2xlarge", "r5ad.4xlarge", "r5ad.large", "r5ad.xlarge", "r5d.4xlarge", "r5d.8xlarge", "r5d.12xlarge", "r5d.xlarge", "r5d.16xlarge", "r5d.24xlarge", "r5d.metal", "r5d.2xlarge", "r5d.large", "t2.xlarge", "t2.large", "t2.small", "t2.medium", "t2.2xlarge", "t2.micro", "t3.xlarge", "t3.large", "t3.small", "t3.medium", "t3.micro", "t3.2xlarge", "t3a.xlarge", "t3a.2xlarge", "t3a.large", "t3a.medium", "t3a.small", "t3a.micro", "z1d.6xlarge", "z1d.3xlarge", "z1d.12xlarge", "z1d.large", "z1d.2xlarge", "z1d.xlarge"]
}

variable "task_instance_group_instance_min_size" {
  type        = number
  description = "Min number of instances for the Core instance group. Must be at least 1"
  default     = 1
}

variable "task_instance_group_instance_max_size" {
  type        = number
  description = "Max number of instances for the Task instance group. Must be greater or equal to `task_instance_group_instance_min_size`"
  default     = 1
}

variable "task_instance_group_instance_desired_size" {
  type        = number
  description = "Desired number of instances for the Task instance group. Must between of `task_instance_group_instance_min_size` and `task_instance_group_instance_max_size`"
  default     = 1
}

variable "task_instance_group_lifecycle" {
  type        = string
  default     = "SPOT"
  description = "The MrScaler lifecycle for instances in Task group. Allowed values are `SPOT` and `ON_DEMAND`"
}

variable "task_instance_group_ebs_size" {
  type        = number
  description = "Task instances volume size, in gibibytes (GiB)"
  default     = 10
}

variable "task_instance_group_ebs_optimized" {
  type        = bool
  description = "Indicates whether an Amazon EBS volume in the Task instance group is EBS-optimized. Changing this forces a new resource to be created"
  default     = false
}

variable "task_instance_group_ebs_type" {
  type        = string
  description = "Task instances volume type. Valid options are `gp2`, `io1`, `standard` and `st1`"
  default     = "gp2"
}

variable "task_instance_group_ebs_iops" {
  type        = number
  description = "The number of I/O operations per second (IOPS) that the Task volume supports"
  default     = null
}

variable "task_instance_group_ebs_volumes_per_instance" {
  type        = number
  description = "The number of EBS volumes with this configuration to attach to each EC2 instance in the Task instance group"
  default     = 1
}

variable "bootstrap_action" {
  type = list(object({
    path = string
    name = string
    args = list(string)
  }))
  description = "List of bootstrap actions that will be run before Hadoop is started on the cluster nodes"
  default     = []
}

variable "s3_bucket_force_destroy" {
  type        = bool
  default     = false
  description = "A boolean string that indicates all objects should be deleted from the S3 bucket so that the bucket can be destroyed without error. These objects are not recoverable"
}
