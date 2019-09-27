provider "aws" {
  profile                 = "accountDestination"
  shared_credentials_file = "~/.aws/credentials"
  region                  = "eu-west-1"
}
