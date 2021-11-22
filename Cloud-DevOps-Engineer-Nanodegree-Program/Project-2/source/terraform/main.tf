terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

#data "aws_vpc" "this" {
#  tags = {
#    Name = "UdacityVPC"
#  }
#}

data "external" "network-parameters"{
  program = ["jq", ".[0] ../cloudformation/cfn-network-parameters.json"]
}
resource "aws_cloudformation_stack" "udacity-project-2" {
  name = "udacity-project-2"

  parameters = "${data.external.network-parameters.result}"

  template_body = file("../cloudformation/cfn-network.yaml")
  capabilities  = ["CAPABILITY_NAMED_IAM"]

  timeouts {
    create = "10m"
    update = "10m"
  }
  lifecycle {
    prevent_destroy = true
  }
}
