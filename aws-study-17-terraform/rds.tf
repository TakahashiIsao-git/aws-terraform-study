# --------------------------------------------------
# DB Subnet Group
# --------------------------------------------------

# RDSは異なるAvailability ZoneのSubnetを必要とするため、
# 2つのPrivate Subnetを登録する
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

  # Database Engine
  engine         = "mysql"
  engine_version = "8.0"

  # Database Credentials
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  # Instance Settings
  instance_class    = "db.t4g.micro"
  storage_type      = "gp3"
  allocated_storage = 20
  # ストレージ自動拡張時の最大容量（GiB）
  max_allocated_storage = 100
  port                  = 3306

  # Network
  # インターネットから直接アクセスさせないためPrivate Subnetへ配置する
  db_subnet_group_name = aws_db_subnet_group.study_db_subnet_group.name
  # EC2からのみデータベースへ接続できるようにする
  vpc_security_group_ids = [
    aws_security_group.rds_sg.id
  ]
  # インターネットから直接アクセスできないようにする
  publicly_accessible = false

  # 自動バックアップの保持期間（日数）を設定
  backup_retention_period = 7

  # 学習環境のため、削除時の最終スナップショットは作成しない
  skip_final_snapshot = true

  # マイナーバージョンアップデートを自動適用
  auto_minor_version_upgrade = true

  # 学習環境のため、削除保護を無効にする
  deletion_protection = false

  tags = {
    Name = "${var.project_name}-rds"
  }
}