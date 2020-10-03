provider "aws" {
    profile = "default"
    region = "eu-west-1"
    shared_credentials_file = "~/.aws/credentials"
}


terraform {
    backend "s3" {
        bucket = "sample-tf-states"
        key = "eks.tfstate"
        region = "eu-west-1"
        shared_credentials_file = "~/.aws/credentials"
    }
}
