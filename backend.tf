terraform {
  backend "s3" {
    bucket       = "terraform-state-devops-final-project-vmix-woolf-20260714"
    key          = "devops-final-project/terraform.tfstate"
    region       = "us-west-2"
    encrypt      = true
    use_lockfile = true
  }
}