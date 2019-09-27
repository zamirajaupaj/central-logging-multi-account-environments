provider "aws" {
  profile                 = "accountSource"
  shared_credentials_file = "~/.aws/credentials"
  region                  = "eu-west-1"
}
