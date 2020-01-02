provider "aws" {
    profile = "${var.profile}"
    region = "eu-west-1"
    shared_credentials_file = "/path/to/.aws/credentials"
}


terraform {
    backend "s3" {
        bucket = "example-tf-states-sand"
        key = "example-environment-1.tfstate"
        region = "eu-west-1"
        shared_credentials_file = "/path/to/.aws/credentials"
    }
}
