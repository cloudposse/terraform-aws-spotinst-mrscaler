<!-- 














  ** DO NOT EDIT THIS FILE
  ** 
  ** This file was automatically generated by the `build-harness`. 
  ** 1) Make all changes to `README.yaml` 
  ** 2) Run `make init` (you only need to do this once)
  ** 3) Run`make readme` to rebuild this file. 
  **
  ** (We maintain HUNDREDS of open source projects. This is how we maintain our sanity.)
  **















  -->
[![README Header][readme_header_img]][readme_header_link]

[![Cloud Posse][logo]](https://cpco.io/homepage)

# terraform-aws-spotinst-mrscaler [![Codefresh Build Status](https://g.codefresh.io/api/badges/pipeline/cloudposse/terraform-modules%2Fterraform-aws-spotinst-mrscaler?type=cf-1)](https://g.codefresh.io/public/accounts/cloudposse/pipelines/5df2921e8dfc856612edc893) [![Latest Release](https://img.shields.io/github/release/cloudposse/terraform-aws-spotinst-mrscaler.svg)](https://github.com/cloudposse/terraform-aws-spotinst-mrscaler/releases/latest) [![Slack Community](https://slack.cloudposse.com/badge.svg)](https://slack.cloudposse.com)


Terraform module to provision an Elastic MapReduce (EMR) cluster on AWS using a [Spotinst](https://spotinst.com/) AWS MrScaler resource.


---

This project is part of our comprehensive ["SweetOps"](https://cpco.io/sweetops) approach towards DevOps. 
[<img align="right" title="Share via Email" src="https://docs.cloudposse.com/images/ionicons/ios-email-outline-2.0.1-16x16-999999.svg"/>][share_email]
[<img align="right" title="Share on Google+" src="https://docs.cloudposse.com/images/ionicons/social-googleplus-outline-2.0.1-16x16-999999.svg" />][share_googleplus]
[<img align="right" title="Share on Facebook" src="https://docs.cloudposse.com/images/ionicons/social-facebook-outline-2.0.1-16x16-999999.svg" />][share_facebook]
[<img align="right" title="Share on Reddit" src="https://docs.cloudposse.com/images/ionicons/social-reddit-outline-2.0.1-16x16-999999.svg" />][share_reddit]
[<img align="right" title="Share on LinkedIn" src="https://docs.cloudposse.com/images/ionicons/social-linkedin-outline-2.0.1-16x16-999999.svg" />][share_linkedin]
[<img align="right" title="Share on Twitter" src="https://docs.cloudposse.com/images/ionicons/social-twitter-outline-2.0.1-16x16-999999.svg" />][share_twitter]


[![Terraform Open Source Modules](https://docs.cloudposse.com/images/terraform-open-source-modules.svg)][terraform_modules]



It's 100% Open Source and licensed under the [APACHE2](LICENSE).







We literally have [*hundreds of terraform modules*][terraform_modules] that are Open Source and well-maintained. Check them out! 







## Usage


**IMPORTANT:** The `master` branch is used in `source` just as an example. In your code, do not pin to `master` because there may be breaking changes between releases.
Instead pin to the release tag (e.g. `?ref=tags/x.y.z`) of one of our [latest releases](https://github.com/cloudposse/terraform-aws-spotinst-mrscaler/releases).



For a complete example, see [examples/complete](examples/complete).

For automated tests of the complete example using [bats](https://github.com/bats-core/bats-core) and [Terratest](https://github.com/gruntwork-io/terratest) (which tests and deploys the example on AWS), see [test](test).

```hcl
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
  source     = "git::https://github.com/cloudposse/terraform-aws-spotinst-mrscaler.git?ref=master"
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
  ebs_root_volume_size              = var.ebs_root_volume_size
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
```






## Makefile Targets
```
Available targets:

  help                                Help screen
  help/all                            Display help for all targets
  help/short                          This help short screen
  lint                                Lint terraform code

```
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| additional_info | A JSON string for selecting additional features such as adding proxy information. Note: Currently there is no API to retrieve the value of this argument after EMR cluster creation from provider, therefore Terraform cannot detect drift from the actual EMR cluster if its value is changed outside Terraform | string | `null` | no |
| applications | A list of applications for the cluster. Valid values are: Flink, Ganglia, Hadoop, HBase, HCatalog, Hive, Hue, JupyterHub, Livy, Mahout, MXNet, Oozie, Phoenix, Pig, Presto, Spark, Sqoop, TensorFlow, Tez, Zeppelin, and ZooKeeper (as of EMR 5.25.0). Case insensitive | list(string) | - | yes |
| attributes | Additional attributes (_e.g._ "1") | list(string) | `<list>` | no |
| bootstrap_action | List of bootstrap actions that will be run before Hadoop is started on the cluster nodes | object | `<list>` | no |
| configurations_json | A JSON string for supplying list of configurations for the EMR cluster. See https://docs.aws.amazon.com/emr/latest/ReleaseGuide/emr-configure-apps.html for more details | string | `null` | no |
| core_instance_group_ebs_iops | The number of I/O operations per second (IOPS) that the Core volume supports | number | `null` | no |
| core_instance_group_ebs_size | Core instances volume size, in gibibytes (GiB) | number | - | yes |
| core_instance_group_ebs_type | Core instances volume type. Valid options are `gp2`, `io1`, `standard` and `st1` | string | `gp2` | no |
| core_instance_group_ebs_volumes_per_instance | The number of EBS volumes with this configuration to attach to each EC2 instance in the Core instance group | number | `1` | no |
| core_instance_group_instance_desired_size | Desired number of instances for the Core instance group. Must between of `core_instance_group_instance_min_size` and `core_instance_group_instance_max_size` | number | `1` | no |
| core_instance_group_instance_max_size | Max number of instances for the Core instance group. Must be greater or equal to `core_instance_group_instance_min_size` | number | `1` | no |
| core_instance_group_instance_min_size | Min number of instances for the Core instance group. Must be at least 1 | number | `1` | no |
| core_instance_group_instance_types | EC2 instance type for all instances in the Core instance group | list(string) | `<list>` | no |
| core_instance_group_lifecycle | The MrScaler lifecycle for instances in core group. Allowed values are `SPOT` and `ON_DEMAND` | string | `SPOT` | no |
| create_task_instance_group | Whether to create an instance group for Task nodes. For more info: https://www.terraform.io/docs/providers/aws/r/emr_instance_group.html, https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-master-core-task-nodes.html | bool | `false` | no |
| custom_ami_id | A custom Amazon Linux AMI for the cluster (instead of an EMR-owned AMI). Available in Amazon EMR version 5.7.0 and later | string | `null` | no |
| delimiter | Delimiter between `namespace`, `stage`, `name` and `attributes` | string | `-` | no |
| enabled | Set to false to prevent the module from creating any resources | bool | `true` | no |
| instance_weights | Describes the instance and weights. Check out [Elastigroup Weighted Instances](https://api.spotinst.com/elastigroup-for-aws/concepts/general-concepts/elastigroup-capacity-instances-or-weighted) for more info. | object | `<list>` | no |
| keep_job_flow_alive_when_no_steps | Switch on/off run cluster with no steps or when all steps are complete | bool | `true` | no |
| key_name | Amazon EC2 key pair that can be used to ssh to the master node as the user called `hadoop` | string | `null` | no |
| log_uri | The path to the Amazon S3 location where logs for this cluster are stored | string | `null` | no |
| master_allowed_cidr_blocks | List of CIDR blocks to be allowed to access the master instances | list(string) | `<list>` | no |
| master_allowed_security_groups | List of security groups to be allowed to connect to the master instances | list(string) | `<list>` | no |
| master_instance_group_ebs_iops | The number of I/O operations per second (IOPS) that the Master volume supports | number | `null` | no |
| master_instance_group_ebs_size | Master instances volume size, in gibibytes (GiB) | number | - | yes |
| master_instance_group_ebs_type | Master instances volume type. Valid options are `gp2`, `io1`, `standard` and `st1` | string | `gp2` | no |
| master_instance_group_ebs_volumes_per_instance | The number of EBS volumes with this configuration to attach to each EC2 instance in the Master instance group | number | `1` | no |
| master_instance_group_instance_types | EC2 instance types for all instances in the Master instance group | list(string) | `<list>` | no |
| master_instance_group_lifecycle | The MrScaler lifecycle for instances in master group. Allowed values are `SPOT` and `ON_DEMAND` | string | `SPOT` | no |
| name | Name of the application | string | - | yes |
| namespace | Namespace (e.g. `eg` or `cp`) | string | `` | no |
| provisioning_timeout | The amount of time (minutes) after which the cluster perform provisioning_timeout_action if it's still in provisioning status. | number | `15` | no |
| provisioning_timeout_action | The action to take if the timeout is exceeded. Valid values: `terminate`, `terminateAndRetry` | string | `terminate` | no |
| region | AWS region | string | - | yes |
| release_label | The release label for the Amazon EMR release. https://docs.aws.amazon.com/emr/latest/ReleaseGuide/emr-release-5x.html | string | `emr-5.25.0` | no |
| repo_upgrade_on_boot | Specifies the type of updates that are applied from the Amazon Linux AMI package repositories when an instance boots using the AMI. Possible values include: `SECURITY`, `NONE` | string | `NONE` | no |
| route_table_id | Route table ID for the VPC S3 Endpoint when launching the EMR cluster in a private subnet. Required when `subnet_type` is `private` | string | `` | no |
| s3_bucket_force_destroy | A boolean string that indicates all objects should be deleted from the S3 bucket so that the bucket can be destroyed without error. These objects are not recoverable | bool | `false` | no |
| security_configuration | The security configuration name to attach to the EMR cluster. Only valid for EMR clusters with `release_label` 4.8.0 or greater. See https://www.terraform.io/docs/providers/aws/r/emr_security_configuration.html for more info | string | `null` | no |
| slave_allowed_cidr_blocks | List of CIDR blocks to be allowed to access the slave instances | list(string) | `<list>` | no |
| slave_allowed_security_groups | List of security groups to be allowed to connect to the slave instances | list(string) | `<list>` | no |
| stage | Stage (e.g. `prod`, `dev`, `staging`) | string | `` | no |
| subnet_id | VPC subnet ID where you want the job flow to launch. Cannot specify the `cc1.4xlarge` instance type for nodes of a job flow launched in a Amazon VPC | string | - | yes |
| subnet_type | Type of VPC subnet ID where you want the job flow to launch. Supported values are `private` or `public` | string | `private` | no |
| tags | Additional tags (_e.g._ { BusinessUnit : ABC }) | map(string) | `<map>` | no |
| task_instance_group_ebs_iops | The number of I/O operations per second (IOPS) that the Task volume supports | number | `null` | no |
| task_instance_group_ebs_optimized | Indicates whether an Amazon EBS volume in the Task instance group is EBS-optimized. Changing this forces a new resource to be created | bool | `false` | no |
| task_instance_group_ebs_size | Task instances volume size, in gibibytes (GiB) | number | `10` | no |
| task_instance_group_ebs_type | Task instances volume type. Valid options are `gp2`, `io1`, `standard` and `st1` | string | `gp2` | no |
| task_instance_group_ebs_volumes_per_instance | The number of EBS volumes with this configuration to attach to each EC2 instance in the Task instance group | number | `1` | no |
| task_instance_group_instance_desired_size | Desired number of instances for the Task instance group. Must between of `task_instance_group_instance_min_size` and `task_instance_group_instance_max_size` | number | `1` | no |
| task_instance_group_instance_max_size | Max number of instances for the Task instance group. Must be greater or equal to `task_instance_group_instance_min_size` | number | `1` | no |
| task_instance_group_instance_min_size | Min number of instances for the Core instance group. Must be at least 1 | number | `1` | no |
| task_instance_group_instance_types | EC2 instance types for all instances in the Task instance group | list(string) | `<list>` | no |
| task_instance_group_lifecycle | The MrScaler lifecycle for instances in Task group. Allowed values are `SPOT` and `ON_DEMAND` | string | `SPOT` | no |
| termination_protection | Switch on/off termination protection (default is false, except when using multiple master nodes). Before attempting to destroy the resource when termination protection is enabled, this configuration must be applied with its value set to false | bool | `false` | no |
| vpc_id | VPC ID to create the cluster in (e.g. `vpc-a22222ee`) | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| bucket_arn | S3 bucket ARN |
| bucket_domain_name | FQDN of the S3 bucket |
| bucket_id | S3 bucket ID |
| cluster_id | EMR cluster ID |
| cluster_name | EMR cluster name |
| master_host | Master public DNS |
| master_public_dns | Master public DNS |
| master_security_group_id | Master security group ID |
| slave_security_group_id | Slave security group ID |




## Share the Love 

Like this project? Please give it a ★ on [our GitHub](https://github.com/cloudposse/terraform-aws-spotinst-mrscaler)! (it helps us **a lot**) 

Are you using this project or any of our other projects? Consider [leaving a testimonial][testimonial]. =)


## Related Projects

Check out these related projects.

- [terraform-aws-rds-cluster](https://github.com/cloudposse/terraform-aws-rds-cluster) - Terraform module to provision an RDS Aurora cluster for MySQL or Postgres
- [terraform-aws-rds](https://github.com/cloudposse/terraform-aws-rds) - Terraform module to provision AWS RDS instances
- [terraform-aws-rds-cloudwatch-sns-alarms](https://github.com/cloudposse/terraform-aws-rds-cloudwatch-sns-alarms) - Terraform module that configures important RDS alerts using CloudWatch and sends them to an SNS topic



## Help

**Got a question?** We got answers. 

File a GitHub [issue](https://github.com/cloudposse/terraform-aws-spotinst-mrscaler/issues), send us an [email][email] or join our [Slack Community][slack].

[![README Commercial Support][readme_commercial_support_img]][readme_commercial_support_link]

## DevOps Accelerator for Startups


We are a [**DevOps Accelerator**][commercial_support]. We'll help you build your cloud infrastructure from the ground up so you can own it. Then we'll show you how to operate it and stick around for as long as you need us. 

[![Learn More](https://img.shields.io/badge/learn%20more-success.svg?style=for-the-badge)][commercial_support]

Work directly with our team of DevOps experts via email, slack, and video conferencing.

We deliver 10x the value for a fraction of the cost of a full-time engineer. Our track record is not even funny. If you want things done right and you need it done FAST, then we're your best bet.

- **Reference Architecture.** You'll get everything you need from the ground up built using 100% infrastructure as code.
- **Release Engineering.** You'll have end-to-end CI/CD with unlimited staging environments.
- **Site Reliability Engineering.** You'll have total visibility into your apps and microservices.
- **Security Baseline.** You'll have built-in governance with accountability and audit logs for all changes.
- **GitOps.** You'll be able to operate your infrastructure via Pull Requests.
- **Training.** You'll receive hands-on training so your team can operate what we build.
- **Questions.** You'll have a direct line of communication between our teams via a Shared Slack channel.
- **Troubleshooting.** You'll get help to triage when things aren't working.
- **Code Reviews.** You'll receive constructive feedback on Pull Requests.
- **Bug Fixes.** We'll rapidly work with you to fix any bugs in our projects.

## Slack Community

Join our [Open Source Community][slack] on Slack. It's **FREE** for everyone! Our "SweetOps" community is where you get to talk with others who share a similar vision for how to rollout and manage infrastructure. This is the best place to talk shop, ask questions, solicit feedback, and work together as a community to build totally *sweet* infrastructure.

## Newsletter

Sign up for [our newsletter][newsletter] that covers everything on our technology radar.  Receive updates on what we're up to on GitHub as well as awesome new projects we discover. 

## Office Hours

[Join us every Wednesday via Zoom][office_hours] for our weekly "Lunch & Learn" sessions. It's **FREE** for everyone! 

[![zoom](https://img.cloudposse.com/fit-in/200x200/https://cloudposse.com/wp-content/uploads/2019/08/Powered-by-Zoom.png")][office_hours]

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/cloudposse/terraform-aws-spotinst-mrscaler/issues) to report any bugs or file feature requests.

### Developing

If you are interested in being a contributor and want to get involved in developing this project or [help out](https://cpco.io/help-out) with our other projects, we would love to hear from you! Shoot us an [email][email].

In general, PRs are welcome. We follow the typical "fork-and-pull" Git workflow.

 1. **Fork** the repo on GitHub
 2. **Clone** the project to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Pull Request** so that we can review your changes

**NOTE:** Be sure to merge the latest changes from "upstream" before making a pull request!


## Copyright

Copyright © 2017-2019 [Cloud Posse, LLC](https://cpco.io/copyright)



## License 

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) 

See [LICENSE](LICENSE) for full details.

    Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at

      https://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.









## Trademarks

All other trademarks referenced herein are the property of their respective owners.

## About

This project is maintained and funded by [Cloud Posse, LLC][website]. Like it? Please let us know by [leaving a testimonial][testimonial]!

[![Cloud Posse][logo]][website]

We're a [DevOps Professional Services][hire] company based in Los Angeles, CA. We ❤️  [Open Source Software][we_love_open_source].

We offer [paid support][commercial_support] on all of our projects.  

Check out [our other projects][github], [follow us on twitter][twitter], [apply for a job][jobs], or [hire us][hire] to help with your cloud strategy and implementation.



### Contributors

|  [![Igor Rodionov][goruha_avatar]][goruha_homepage]<br/>[Igor Rodionov][goruha_homepage] | [![Erik Osterman][osterman_avatar]][osterman_homepage]<br/>[Erik Osterman][osterman_homepage] | [![Andriy Knysh][aknysh_avatar]][aknysh_homepage]<br/>[Andriy Knysh][aknysh_homepage] |
|---|---|---|

  [goruha_homepage]: https://github.com/goruha
  [goruha_avatar]: https://img.cloudposse.com/150x150/https://github.com/goruha.png
  [osterman_homepage]: https://github.com/osterman
  [osterman_avatar]: https://img.cloudposse.com/150x150/https://github.com/osterman.png
  [aknysh_homepage]: https://github.com/aknysh
  [aknysh_avatar]: https://img.cloudposse.com/150x150/https://github.com/aknysh.png

[![README Footer][readme_footer_img]][readme_footer_link]
[![Beacon][beacon]][website]

  [logo]: https://cloudposse.com/logo-300x69.svg
  [docs]: https://cpco.io/docs?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-spotinst-mrscaler&utm_content=docs
  [website]: https://cpco.io/homepage?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-spotinst-mrscaler&utm_content=website
  [github]: https://cpco.io/github?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-spotinst-mrscaler&utm_content=github
  [jobs]: https://cpco.io/jobs?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-spotinst-mrscaler&utm_content=jobs
  [hire]: https://cpco.io/hire?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-spotinst-mrscaler&utm_content=hire
  [slack]: https://cpco.io/slack?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-spotinst-mrscaler&utm_content=slack
  [linkedin]: https://cpco.io/linkedin?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-spotinst-mrscaler&utm_content=linkedin
  [twitter]: https://cpco.io/twitter?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-spotinst-mrscaler&utm_content=twitter
  [testimonial]: https://cpco.io/leave-testimonial?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-spotinst-mrscaler&utm_content=testimonial
  [office_hours]: https://cloudposse.com/office-hours?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-spotinst-mrscaler&utm_content=office_hours
  [newsletter]: https://cpco.io/newsletter?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-spotinst-mrscaler&utm_content=newsletter
  [email]: https://cpco.io/email?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-spotinst-mrscaler&utm_content=email
  [commercial_support]: https://cpco.io/commercial-support?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-spotinst-mrscaler&utm_content=commercial_support
  [we_love_open_source]: https://cpco.io/we-love-open-source?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-spotinst-mrscaler&utm_content=we_love_open_source
  [terraform_modules]: https://cpco.io/terraform-modules?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-spotinst-mrscaler&utm_content=terraform_modules
  [readme_header_img]: https://cloudposse.com/readme/header/img
  [readme_header_link]: https://cloudposse.com/readme/header/link?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-spotinst-mrscaler&utm_content=readme_header_link
  [readme_footer_img]: https://cloudposse.com/readme/footer/img
  [readme_footer_link]: https://cloudposse.com/readme/footer/link?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-spotinst-mrscaler&utm_content=readme_footer_link
  [readme_commercial_support_img]: https://cloudposse.com/readme/commercial-support/img
  [readme_commercial_support_link]: https://cloudposse.com/readme/commercial-support/link?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-spotinst-mrscaler&utm_content=readme_commercial_support_link
  [share_twitter]: https://twitter.com/intent/tweet/?text=terraform-aws-spotinst-mrscaler&url=https://github.com/cloudposse/terraform-aws-spotinst-mrscaler
  [share_linkedin]: https://www.linkedin.com/shareArticle?mini=true&title=terraform-aws-spotinst-mrscaler&url=https://github.com/cloudposse/terraform-aws-spotinst-mrscaler
  [share_reddit]: https://reddit.com/submit/?url=https://github.com/cloudposse/terraform-aws-spotinst-mrscaler
  [share_facebook]: https://facebook.com/sharer/sharer.php?u=https://github.com/cloudposse/terraform-aws-spotinst-mrscaler
  [share_googleplus]: https://plus.google.com/share?url=https://github.com/cloudposse/terraform-aws-spotinst-mrscaler
  [share_email]: mailto:?subject=terraform-aws-spotinst-mrscaler&body=https://github.com/cloudposse/terraform-aws-spotinst-mrscaler
  [beacon]: https://ga-beacon.cloudposse.com/UA-76589703-4/cloudposse/terraform-aws-spotinst-mrscaler?pixel&cs=github&cm=readme&an=terraform-aws-spotinst-mrscaler
