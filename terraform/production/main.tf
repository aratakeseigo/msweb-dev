terraform {
  required_providers  {
    aws = "~> 2.7"
  }
}
terraform {
  backend "s3" {
    bucket = "securebox-terraform"
    region = "ap-northeast-1"
    key = "production.tfstate"
    encrypt = true
  }
}

provider "aws" {
  region     = "ap-northeast-1"
}

data "aws_s3_bucket" "securebox-terraform" {
  bucket = "securebox-terraform"
}
module "sb" {
  source   = "../module/sb"
  aws_account_id = "843409087087"
  aws_region = "ap-northeast-1"

  stage = "production"
  ecr_execution_role_arn = "arn:aws:iam::843409087087:role/ecsTaskExecutionRole"
  aws_vpc_id = "vpc-6ad0130e"
  aws_subnets=["subnet-e735e0bf","subnet-2c75f65a"]

  #下記2つはセット
  alb_seculity_group_id = "sg-feb1f798"
  ecs_seculity_group_id = "sg-0b2cf46c410ce1838"
}
