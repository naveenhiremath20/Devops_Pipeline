terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region     = "us-west-2"
  access_key = ""
  secret_key = ""
}

resource "aws_instance" "app_server" {
  ami           = "ami-0747e613a2a1ff483"
  instance_type = "t2.micro"
  key_name      = "terraformkeypair"
  user_data     = <<EOF
      #!/bin/bash
      sudo yum update
      sudo wget -O /etc/yum.repos.d/jenkins.repo \
      https://pkg.jenkins.io/redhat-stable/jenkins.repo
      sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
      sudo yum upgrade
      sudo dnf install java-11-amazon-corretto -y
      sudo yum install jenkins -y
      sudo systemctl enable jenkins
      sudo systemctl start jenkins
      # http://<your_server_public_DNS>:8080
  EOF
  tags = {
    Name        = "Jenkins_Instance"
    Environment = "Dev"
  }
}



