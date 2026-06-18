# ----------------------------------
# 変数定義
# ----------------------------------

# ----------------------------------
# Project
# ----------------------------------

variable "project_name" {
  type = string
}

# ----------------------------------
# VPC
# ----------------------------------

variable "vpc_cidr" {
  type = string
}

# ----------------------------------
# Subnet
# ----------------------------------

variable "public_subnet_1a_cidr" {
  type = string
}

variable "public_subnet_1c_cidr" {
  type = string
}

variable "private_subnet_1a_cidr" {
  type = string
}

variable "private_subnet_1c_cidr" {
  type = string
}

# ----------------------------------
# Security Groups
# ----------------------------------

variable "my_ip" {
  type = string
}

# ----------------------------------
# EC2
# ----------------------------------

# EC2インスタンスタイプ
variable "instance_type" {
  type = string
}

# AWSキーペア名
variable "key_name" {
  type = string
}

# ----------------------------------
# RDS
# ----------------------------------

# データベース名
variable "db_name" {
  type = string
}

# マスターユーザ名
variable "db_username" {
  type = string
}

# マスターパスワード
# plan/apply時はマスク表示 
variable "db_password" {
  type      = string
  sensitive = true
}