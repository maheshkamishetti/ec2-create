variable "common_tags" {
  default = {
    Project     = "live"
    Environment = "dev"
    Terraform   = "true"
  }
}

variable "project_name" {
  default = "live"
}
variable "environment" {
  default = "dev"
}
