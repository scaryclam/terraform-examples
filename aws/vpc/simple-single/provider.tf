provider "aws" {
    profile = "default"
    region = "eu-west-1"
    shared_credentials_file = "~/.aws/credentials"
}


# Optional: remote state. Just comment this out to use a local state
terraform {
    backend "s3" {
        bucket = "sample-tf-states"
        key = "simple-vpc-single.tfstate"
        region = "eu-west-1"
        shared_credentials_file = "~/.aws/credentials"
    }
}
