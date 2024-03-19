provider "aws" {
  profile = var.profile
  region  = var.aws_region
  #access_key = "AKIAYFMGZTS445IECDHV"
  #secret_key = "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"

}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "<= 4.18.0"
    }
  }
  backend "s3" {
    bucket = "testbucketmadhu.com"
    key    = "state/terraform.tfstate"
    #region = var.aws_region
    region = "us-east-2"
    encrypt        	   = true
    dynamodb_table = "mycomponents_tf_lockid"
  }


}
