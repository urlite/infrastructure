terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.13.0"
    }
  }
}

provider "aws" {
  region = "eu-west-3"
}
provider "aws" {
  alias = "nvirginia"
  region = "us-east-1"
}
