# ----------
# 変数定義
# ----------
variable "project_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

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

variable "my_ip" {
  type = string
}