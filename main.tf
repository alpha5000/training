#
# DO NOT DELETE THESE LINES!
#
# Your subnet ID is:
#
#     subnet-7e50c21a
#
# Your security group ID is:
#
#     sg-29ef374e
#
# Your AMI ID is:
#
#     ami-30217250
#
# Your Identity is:
#
#     autodesk-eagle
#


variable "aws_access_key" {
  type = "string"
}

variable "aws_secret_key" {
  type = "string"
}

variable "aws_region" {
  type    = "string"
  default = "us-west-1"
}

variable "num_webs"{
  default = "2"
}

# access_key = "AKIAIWZ324CS6BM5UB5A"
# secret_key = "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

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

resource "aws_instance" "web" {
  ami                    = "ami-30217250"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-7e50c21a"
  vpc_security_group_ids = ["sg-29ef374e"]
  count                  = "${var.num_webs}"

  tags {
    Identity = "autodesk-eagle"
    service  = "autodesk-eagle-nest"
    location = "us-west-1"
    "Name" = "web ${count.index+1}/${var.num_webs}"
  }
}

output "public_ip" {
  value = ["${aws_instance.web.*.public_ip}"]
}

output "public_dns" {
  value = ["${aws_instance.web.*.public_dns}"]
}

terraform {
  backend "enterprise" {
    environment = "centram/training"
    token = "JXoZtDuDFTkfZw.atlasv1.J1w3EHIiULPL8DoRuKcIFtSBXqsMCDiVGrC3q9F80Ghe9FZfbGjmXU0WTZazoEHdTyw"
  }
}