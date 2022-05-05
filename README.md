# terraform-lambda-start-stop
Terraform module to create a lambda function to start/Stop EC2 instances with a "scheduled-start-stop" tag triggered by two cron Eventbridge resources. 
## Features
- Creates two AWS Eventbridge resources.
- Attaches the resources to the default EventBridge Bus.
- Lambda function is stored in an S3 Bucket.
- Creates a Lambda function that start/stops tagged instances based on the EventBridge Resource.

## Usage
Specify the cron expression for the `waketime` and `bedtime` variables.
An example is provided in the `example.tf` file.

```shell
$terraform init
$terraform plan
$terraform apply
```
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.2.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | ~> 2.2.0 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.bedtime](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_rule.waketime](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.lambda_bedtime](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_event_target.lambda_wakeup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_iam_role.lambda_exec](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.cloudwatch_ec2_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.lambda_start_stop](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.allow_cloudwatch_bedtime_to_invoke](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.allow_cloudwatch_waktetime_to_invoke](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_s3_bucket.lambda_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_object.lambda_rest_api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [random_pet.lambda_bucket_name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |
| [archive_file.lambda_rest_api](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bedtime"></a> [bedtime](#input\_bedtime) | Cron Expression for bed time | `any` | n/a | yes |
| <a name="input_start_event_name"></a> [start\_event\_name](#input\_start\_event\_name) | Name of the Start event detail in Event Bridge | `string` | `"start-event"` | no |
| <a name="input_stop_event_name"></a> [stop\_event\_name](#input\_stop\_event\_name) | Name of the Stop event detail in Event Bridge | `string` | `"stop-event"` | no |
| <a name="input_tag_key"></a> [tag\_key](#input\_tag\_key) | Only affects instances tagged with this key | `string` | `"scheduled-start-stop"` | no |
| <a name="input_tag_value"></a> [tag\_value](#input\_tag\_value) | Tag value for the instances | `string` | `"true"` | no |
| <a name="input_waketime"></a> [waketime](#input\_waketime) | Cron expression for wake up time | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_S3_bucket_name"></a> [S3\_bucket\_name](#output\_S3\_bucket\_name) | S3 bucket name where the lambda functions is stored |
| <a name="output_start_event_rule_arn"></a> [start\_event\_rule\_arn](#output\_start\_event\_rule\_arn) | ARN of the Start Eventbridge Rule |
| <a name="output_stop_event_rule_arn"></a> [stop\_event\_rule\_arn](#output\_stop\_event\_rule\_arn) | ARN of the Stop Eventbridge Rule |
<!-- END_TF_DOCS -->