provider "aws" {
    profile = "source-profile"
    region = "eu-west-1"
    shared_credentials_file = "~/.aws/credentials"
}

provider "aws" {
    profile = "target-profile"
    region = "eu-west-1"
    shared_credentials_file = "~/.aws/credentials"
}


# Optional: remote state. Just comment this out to use a local state
terraform {
    backend "s3" {
        bucket = "test-tf-states"
        key = "example-environment-3.tfstate"
        region = "eu-west-1"
        shared_credentials_file = "~/.aws/credentials"
    }
}
