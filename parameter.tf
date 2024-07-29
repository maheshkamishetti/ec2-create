resource "aws_ssm_parameter" "instance_id" {
  name  = "/${var.project_name}/${var.environment}/instance_id"
  type  = "String"
  value = module.app.id
}