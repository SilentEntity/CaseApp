provider "aws" {
  region  = var.region
  version = ">=3.7,<=3.11"
}
variable "region" {
  default = "ap-south-1"
}

variable "key_name" {
  default = "SonarQube"
}
variable "security_id" {
  default = "CaseApp"
}
variable "pvt_key_name" {
  default = "/home/silent/.ssh/SonarQube.pem"
}

data "aws_availability_zones" "zone_east" {}

data "aws_ami" "ubuntu_ami" {
  most_recent = "true"
  owners      = ["099720109477"]
  
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04*"]
  }

}
resource "aws_instance" "backend" {
  ami               = data.aws_ami.ubuntu_ami.id
  instance_type     = "t2.micro"
  key_name    = var.key_name
  vpc_security_group_ids = [var.security_id]
  availability_zone = data.aws_availability_zones.zone_east.names[count.index]
  count             = 1
  lifecycle {
    prevent_destroy = false
  }
  tags = {
    Name = "Backend-App"
  }
  connection { 
    type = "ssh"
    user = "ubuntu"
    private_key = file(var.pvt_key_name)
    host  = self.public_ip 
  }

  provisioner "remote-exec" {
    inline = [
      "python3 --version",
      "sudo apt-get update",
      "sudo apt-get install python3-pip -y",
      "sudo ufw allow 9090",
      "export PATH=$PATH:/home/ubuntu/.local/bin",
      "git clone https://github.com/SilentEntity/CaseApp.git",
      "cd CaseApp",
      "pip3 install -r requirements.txt",
      "sudo cp terra/AWS_WSGI.service /etc/systemd/system/",
      "sudo systemctl daemon-reload",
      "sudo systemctl start AWS_WSGI.service",
      "sudo systemctl enable AWS_WSGI.service"
    ]
}
output "backend_public_ips" {
  value = aws_instance.backend.*.public_ip
}
output "backend_public_dns" {
  value = aws_instance.backend.*.public_dns
}