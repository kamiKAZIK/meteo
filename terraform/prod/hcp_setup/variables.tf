variable "region" {
  type = string
  default = "eu-central-1"
}

variable "tfc_hostname" {
  type = string
  default = "app.terraform.io"
}

variable "tfc_aws_audience" {
  type = string
  default = "aparatus-meteo-prod"
}

variable "tfc_organization_name" {
  type = string
  default = "aparatus"
}

variable "tfc_project_name" {
  type = string
  default = "meteo"
}

variable "tfc_workspace_name" {
  type = string
  default = "meteo-prod"
}
