# ----------------------------------
# Project
# ----------------------------------
variable "project_name" {
  description = "Project name used for resource naming."
  type        = string
}

# ----------------------------------
# VPC
# ----------------------------------
variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

# ----------------------------------
# Subnet
# ----------------------------------
variable "public_subnet_1a_cidr" {
  description = "CIDR block for the public subnet in ap-northeast-1a."
  type        = string
}

variable "public_subnet_1c_cidr" {
  description = "CIDR block for the public subnet in ap-northeast-1c."
  type        = string
}

variable "private_subnet_1a_cidr" {
  description = "CIDR block for the private subnet in ap-northeast-1a."
  type        = string
}

variable "private_subnet_1c_cidr" {
  description = "CIDR block for the private subnet in ap-northeast-1c."
  type        = string
}

# ----------------------------------
# Security Groups
# ----------------------------------
variable "my_ip" {
  description = "IP address allowed to access EC2 via SSH."
  type        = string
}

# ----------------------------------
# EC2
# ----------------------------------
variable "instance_type" {
  description = "EC2 instance type."
  type        = string
}

variable "key_name" {
  description = "AWS key pair name."
  type        = string
}

# ----------------------------------
# RDS
# ----------------------------------
variable "db_name" {
  description = "Database name for the RDS instance."
  type        = string
}

variable "db_username" {
  description = "Master username for the RDS instance."
  type        = string
}

variable "db_password" {
  description = "Master password for the RDS instance."
  type        = string
  sensitive   = true
}

# ----------------------------------
# CloudWatch Alarm
# ----------------------------------
variable "cpu_alarm_threshold" {
  description = "CPU utilization percentage that triggers the CloudWatch alarm."
  type        = number

  validation {
    condition     = var.cpu_alarm_threshold >= 1 && var.cpu_alarm_threshold <= 100
    error_message = "The CPU alarm threshold must be between 1 and 100."
  }
}