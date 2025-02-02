terraform {
  backend "s3" {
    bucket = "311141525611-terraform-states"
    key    = "states/severless-app-proj"
    region = "us-east-1"
  }
}
