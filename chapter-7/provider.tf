# provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

# backend
terraform {
  backend "s3" {
    bucket               = "tf-handson-takahashi"
    workspace_key_prefix = "chapter-7" # 環境ごとにフォルダーは切っていない
    key                  = "terraform.tfstate"
    region               = "ap-northeast-1"
  }
}