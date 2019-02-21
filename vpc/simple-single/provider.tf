provider "aws" {
    profile = "default"
    region = "eu-west-1"
    shared_credentials_file = "/path/to/.aws/credentials"
}


# Optional: remote state. Just comment this out to use a local state
terraform {
    backend "s3" {
        bucket = "example-tf-states-sand"
        key = "example-environment-1.tfstate"
        region = "eu-west-1"
        shared_credentials_file = "/path/to/.aws/credentials"
    }
}
