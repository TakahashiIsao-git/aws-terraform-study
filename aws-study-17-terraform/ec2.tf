# ----------------------------------
# EC2 Instance
# ----------------------------------

# Public Subnetに配置する学習用Webサーバ
# ALB経由でHTTPリクエストを受け付ける
resource "aws_instance" "study_ec2" {

  # Amazon Linux 2023
  ami           = "ami-09cd9fdbf26acc6b4"
  instance_type = var.instance_type
  key_name      = var.key_name

  subnet_id = aws_subnet.public_subnet_1a.id
  vpc_security_group_ids = [
    aws_security_group.ec2_sg.id
  ]

  # ApacheをインストールしてWebページを作成する
  user_data = <<-EOF
  #!/bin/bash

  # OSを最新化
  dnf update -y

  # Apacheをインストール
  dnf install -y httpd

  # テストページを作成
  echo "Hello AWS Study" > /var/www/html/index.html
  
  # Apacheを起動
  systemctl enable httpd
  systemctl start httpd
  EOF

  tags = {
    Name = "${var.project_name}-ec2"
  }
}