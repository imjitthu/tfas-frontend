terraform {
  backend "s3" {
    bucket = "terraform-state-jithendar"
    key    = "rs-instances/frontend.tfstate"
    region = "us-east-1"
  }
}