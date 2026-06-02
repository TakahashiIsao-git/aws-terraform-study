# backendの定義
terraform {
  backend "s3" {
    bucket = "tf-handson-takahashi"
    key    = "chapter-5/terraform.tfstate"
    region = "ap-northeast-1"
  }
}