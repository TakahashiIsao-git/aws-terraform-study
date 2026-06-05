# ----------
# リソース定義
# ----------
# VPCを作る
resource "aws_vpc" "study_vpc" {

  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# Subnetを作る
# PublicSubnetはALBアクセス用
resource "aws_subnet" "public_subnet_1a" {

  vpc_id                  = aws_vpc.study_vpc.id
  cidr_block              = var.public_subnet_1a_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet1a"
  }
}

resource "aws_subnet" "public_subnet_1c" {

  vpc_id                  = aws_vpc.study_vpc.id
  cidr_block              = var.public_subnet_1c_cidr
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet1c"
  }
}

# PrivateSubnetは外部インターネットから直接アクセスさせない。
resource "aws_subnet" "private_subnet_1a" {

  vpc_id            = aws_vpc.study_vpc.id
  cidr_block        = var.private_subnet_1a_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.project_name}-private-subnet1a"
  }
}

resource "aws_subnet" "private_subnet_1c" {

  vpc_id            = aws_vpc.study_vpc.id
  cidr_block        = var.private_subnet_1c_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.project_name}-private-subnet1c"
  }
}

# EC2へSSH接続して学習を行うため
# Internet GatewayをVPCへ接続する
resource "aws_internet_gateway" "study_igw" {

  vpc_id = aws_vpc.study_vpc.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# Public Subnet用のRoute Table
# 0.0.0.0/0をIGWへ向けてインターネット通信を可能にする
resource "aws_route_table" "public_rt" {

  vpc_id = aws_vpc.study_vpc.id

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

# インターネット向け通信をIGWへ転送する
resource "aws_route" "internet_route" {

  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.study_igw.id
}

# サブネットとルートテーブルの関連付け
resource "aws_route_table_association" "public_1a" {

  subnet_id      = aws_subnet.public_subnet_1a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_1c" {
  subnet_id      = aws_subnet.public_subnet_1c.id
  route_table_id = aws_route_table.public_rt.id
}