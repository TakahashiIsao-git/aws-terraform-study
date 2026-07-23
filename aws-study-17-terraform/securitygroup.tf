# --------------------------------------------------
# ALB Security Group
# --------------------------------------------------

# インターネットからのHTTP通信を受け付けるSecurity Group
resource "aws_security_group" "alb_sg" {

  name        = "${var.project_name}-alb-sg"
  description = "Security group for the Application Load Balancer"
  vpc_id      = aws_vpc.study_vpc.id

  # インターネットからのHTTPアクセスを許可
  ingress {

    description = "Allow HTTP from the Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-alb-sg"
  }
}

# --------------------------------------------------
# EC2 Security Group
# --------------------------------------------------

# EC2へ必要な通信のみ許可するSecurity Group
resource "aws_security_group" "ec2_sg" {

  name        = "${var.project_name}-ec2-sg"
  description = "Security group for the EC2 instance"
  vpc_id      = aws_vpc.study_vpc.id

  # 自分のIPアドレスからのSSH接続を許可
  ingress {

    description = "Allow SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    cidr_blocks = [var.my_ip]
  }

  # ALBからのHTTP通信のみ許可
  ingress {

    description = "Allow HTTP from ALB"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"

    security_groups = [
      aws_security_group.alb_sg.id
    ]
  }

  # Allow all outbound traffic
  egress {

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-ec2-sg"
  }
}

# --------------------------------------------------
# RDS Security Group
# --------------------------------------------------

# EC2からのMySQL接続のみ許可するSecurity Group
resource "aws_security_group" "rds_sg" {

  name        = "${var.project_name}-rds-sg"
  description = "Security group for the RDS instance"
  vpc_id      = aws_vpc.study_vpc.id

  # EC2からのMySQL接続のみ許可
  ingress {

    description = "Allow MySQL from EC2"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"

    security_groups = [
      aws_security_group.ec2_sg.id
    ]
  }

  # Allow all outbound traffic
  egress {

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-rds-sg"
  }
}