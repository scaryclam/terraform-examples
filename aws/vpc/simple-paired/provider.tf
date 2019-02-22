provider "aws" {
    profile = "default"
    region = "eu-west-1"
    shared_credentials_file = "/path/to/.aws/credentials"
}


# Optional: remote state. Just comment this out to use a local state
terraform {
    backend "s3" {
        bucket = "test-tf-states"
        key = "example-environment-2.tfstate"
        region = "eu-west-1"
        shared_credentials_file = "/path/to/.aws/credentials"
    }
}
