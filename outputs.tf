output "cluster_id" {
  value       = join("", spotinst_mrscaler_aws.default.*.id)
  description = "EMR cluster ID"
}

output "cluster_name" {
  value       = join("", spotinst_mrscaler_aws.default.*.name)
  description = "EMR cluster name"
}

output "master_public_dns" {
  //value       = join("", spotinst_mrscaler_aws.default.*.master_public_dns)
  value       = ""
  description = "Master public DNS"
}

output "master_security_group_id" {
  value       = join("", aws_security_group.master.*.id)
  description = "Master security group ID"
}

output "slave_security_group_id" {
  value       = join("", aws_security_group.slave.*.id)
  description = "Slave security group ID"
}

output "bucket_domain_name" {
  value       = module.s3_bucket.bucket_domain_name
  description = "FQDN of the S3 bucket"
}

output "bucket_id" {
  value       = module.s3_bucket.bucket_id
  description = "S3 bucket ID"
}

output "bucket_arn" {
  value       = module.s3_bucket.bucket_arn
  description = "S3 bucket ARN"
}
