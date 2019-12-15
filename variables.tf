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
  default     = []
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
