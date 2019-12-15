region = "us-east-2"

availability_zones = ["us-east-2a"]

vpc_cidr_block = "172.16.0.0/16"

namespace = "eg"

stage = "test"

name = "spotinst-mrscaler"

release_label = "emr-5.25.0"

applications = ["Hive", "Presto"]

core_instance_group_instance_types = ["m4.large"]

core_instance_group_ebs_size = 10

core_instance_group_ebs_type = "gp2"

core_instance_group_ebs_volumes_per_instance = 1

master_instance_group_instance_types = ["m4.large"]

master_instance_group_lifecycle = "SPOT"

master_instance_group_ebs_size = 10

master_instance_group_ebs_type = "gp2"

master_instance_group_ebs_volumes_per_instance = 1

create_task_instance_group = false

ssh_public_key_path = "/secrets"

generate_ssh_key = true
