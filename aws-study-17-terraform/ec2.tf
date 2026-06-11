# ----------------------------------
# EC2 Instance
# ----------------------------------

# 学習用Webサーバ
# PublicSubnetに配置
# ALB経由でHTTPアクセスを受ける
resource "aws_instance" "study_ec2" {

  # Amazon Linux 2023
  ami = "ami-09cd9fdbf26acc6b4"

  instance_type = var.instance_type

  subnet_id = aws_subnet.public_subnet_1a.id

  vpc_security_group_ids = [
    aws_security_group.ec2_sg.id
  ]

  key_name = var.key_name

  user_data = <<-EOF
  #!/bin/bash
  dnf update -y
  dnf install -y httpd

  echo "Hello AWS Study" > /var/www/html/index.html

  systemctl enable httpd
  systemctl start httpd
  EOF

  tags = {
    Name = "${var.project_name}-ec2"
  }
}