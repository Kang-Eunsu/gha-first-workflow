terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }

    backend "s3"{
        bucket         = "testbucketforskkuding"
        key            = "terraform.tfstate"
        region         = aws.region
        dynamodb_table = "terraform-lock"
        encrypt        = true
    }
}

# Configure the AWS Provider
provider "aws" {
    region = "ap-northeast-2"
}

# Create a VPC
resource "aws_vpc" "example" {
    cidr_block = "10.0.0.0/16"
}




