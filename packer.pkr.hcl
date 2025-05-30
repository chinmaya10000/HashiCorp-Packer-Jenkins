packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.0.0"
    }
  }
}
####veera

variable "aws_region" {
  type    = string
  default = "us-east-2"
}

source "amazon-ebs" "ubuntu-node" {
  region           = var.aws_region
  instance_type    = "t2.medium"
  ami_name         = "node-app-ami-{{timestamp}}"
  ssh_username     = "ubuntu"

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    owners      = ["099720109477"]
    most_recent = true
  }
}

build {
  name    = "build-node-app-ami"
  sources = ["source.amazon-ebs.ubuntu-node"]

  provisioner "file" {
    # Copy the entire app directory as /tmp/node-app on remote
    source      = "app"
    destination = "/tmp/node-app"
  }

  provisioner "file" {
    source      = "scripts/install.sh"
    destination = "/tmp/install.sh"
  }

  provisioner "shell" {
    inline = [
      "chmod +x /tmp/install.sh",
      "sudo /tmp/install.sh"
    ]
  }
}
