# This is the provider for the source account
provider "aws" {
    profile = "default"
    region = "eu-west-1"
    shared_credentials_file = "~/.aws/credentials"
}

# This is the provider for the target account
provider "aws" {
  alias = "target"
  region = "eu-west-1"
  shared_credentials_file = "~/.aws/credentials"
  profile = "default"
}

# This will give access to the target account ID
data "aws_caller_identity" "target-account" {
  provider = aws.target
}


# Optional: remote state. Just comment this out to use a local state
terraform {
    backend "s3" {
        bucket = "sample-tf-states"
        key = "simple-vpc-peered.tfstate"
        region = "eu-west-1"
        shared_credentials_file = "~/.aws/credentials"
    }
}
