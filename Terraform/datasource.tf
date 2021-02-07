data "aws_availability_zones" "zone_east" {}

data "aws_ami" "ubuntu_ami" {
  most_recent = "true"
  owners      = ["099720109477"]
  
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04*"]
  }

}

data "aws_vpc" "selected" {
  default = true
}

data "aws_subnet_ids" "subnets" {
  vpc_id = data.aws_vpc.selected.id
}

data "aws_security_groups" "ELB" {
    filter {
        name = "group-name"
        values = ["ELB"]
    }
}