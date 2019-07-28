provider "aws" {
    profile = "default"
    region = "eu-west-1"
    shared_credentials_file = "~/.aws/credentials"
}


terraform {
    backend "s3" {
        bucket = "example-tf-states-sand"
        key = "example-environment-eks-1.tfstate"
        region = "eu-west-1"
        shared_credentials_file = "~/.aws/credentials"
    }
}
