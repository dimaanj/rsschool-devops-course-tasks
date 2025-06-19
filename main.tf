variable "ami" {
  description = "AMI ID for the instance"
  default = "ami-09e6f87a47903347c"
}

variable "type" {
  description = "Instance type"
  default = "t2.micro"
}

resource "aws_instance" "demo" {
  ami           = var.ami
  instance_type = var.type

  tags = {
    name = "My VM"
  }

  lifecycle {
    prevent_destroy = false
  }
}
