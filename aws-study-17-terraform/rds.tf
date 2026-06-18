# --------------------------------------------------
# RDS
# --------------------------------------------------

# --------------------------------------------------
# DB Subnet Group
# --------------------------------------------------

# RDSを配置するPrivate Subnetのグループ
# RDSは異なるAZのSubnetを要求するため、
# PrivateSubnetを2つ登録する
resource "aws_db_subnet_group" "study_db_subnet_group" {

  name = "${var.project_name}-db-subnet-group"

  subnet_ids = [
    aws_subnet.private_subnet_1a.id,
    aws_subnet.private_subnet_1c.id
  ]

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

# --------------------------------------------------
# RDS Instance
# --------------------------------------------------

# EC2からのみ接続可能なMySQLデータベース
# 外部インターネットからはアクセス不可
resource "aws_db_instance" "study_rds" {

  identifier = "${var.project_name}-rds"

  engine         = "mysql"
  engine_version = "8.0"

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  instance_class    = "db.t4g.micro"
  storage_type      = "gp3"
  allocated_storage = 20

  # 自動で容量を増やす上限サイズ。
  # max_allocated_storage = 100

  port = 3306

  # Private Subnetへ配置
  db_subnet_group_name = aws_db_subnet_group.study_db_subnet_group.name

  # EC2からのみ接続許可
  vpc_security_group_ids = [
    aws_security_group.rds_sg.id
  ]

  publicly_accessible = false

  # 自動バックアップの保持期間（日数）を設定
  # backup_retention_period = 7

  # 学習環境のため最終スナップショットを作成しない
  skip_final_snapshot = true

  # auto_minor_version_upgrade = true

  # 削除保護を無効
  deletion_protection = false

  tags = {
    Name = "${var.project_name}-rds"
  }
}