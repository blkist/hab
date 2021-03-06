### Global ###
variable "account_numbers" {
  type = "list"
  default = []
}

variable "region" {
  description = "AWS Region to target"
  type = "string"
  default = "us-east-1"
}

variable "name_prefix" {
  description = "String to use as prefix on object names"
  type = "string"
}

variable "access_key" {
  description = "AWS access key"
  type = "string"
  default = ""
}

variable "secret_key" {
  description = "AWS secret key"
  type = "string"
  default = ""
}

variable "token" {
  description = "MFA Token retrieved with sts get-session-token"
  type = "string"
  default = ""
}

variable "env_name" {
  description = "Environment name string to be used for decisions and name generation"
  type = "string"
}

variable "data_bucket_name" {
  description = "Name of data bucket for firehose destination"
  type = "string"
  default = "hab-data-test-bucket-name"
}
