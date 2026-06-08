# --------------------------------------------------
# ALB Security Group
# --------------------------------------------------

resource "aws_security_group" "alb_sg" {
  
  name = "${var.project_name}-alb-sg"
  description = "ALB Security Group"
  vpc_id = aws_vpc.study_vpc.id

  # インターネットからのHTTPアクセスを許可
  ingress {
    
    description = "HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    
    from_port = 0
    to_port = 0
    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-alb-sg"
  }
}

# --------------------------------------------------
# EC2 Security Group
# --------------------------------------------------

resource "aws_security_group" "ec2_sg" {
  
  name = "${var.project_name}-ec2-sg"
  description = "EC2 Security Group"
  vpc_id = aws_vpc.study_vpc.id

  ingress {

    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"

    cidr_blocks = [var.my_ip]
  }

  ingress {

    description = "HTTP from ALB"
    from_port = 80
    to_port = 80
    protocol = "tcp"

    security_groups = [
        aws_security_group.alb_sg.id
    ]
  }

  egress {

    from_port = 0
    to_port = 0
    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-ec2-sg"
  }
}

# --------------------------------------------------
# RDS Security Group
# --------------------------------------------------

resource "aws_security_group" "rds_sg" {
  
  name = "${var.project_name}-rds-sg"
  description = "RDS Security Group"
  vpc_id = aws_vpc.study_vpc.id

  # EC2からのMySQL接続のみ許可
  ingress {

    description = "MySQL"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"

    security_groups = [
        aws_security_group.ec2_sg.id
    ]
  }

  egress {

    from_port = 0
    to_port = 0
    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-rds-sg"
  }
}