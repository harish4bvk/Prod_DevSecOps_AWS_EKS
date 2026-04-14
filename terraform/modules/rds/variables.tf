variable "db_name" {
  description = "Database name"
  type        = string
}

variable "username" {
  description = "DB username"
  type        = string
}

variable "password" {
  description = "DB password"
  type        = string
  sensitive   = true
}

variable "subnet_ids" {
  description = "Private subnet IDs"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}