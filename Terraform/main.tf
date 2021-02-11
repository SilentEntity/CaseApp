resource "aws_instance" "backend" {
  ami               = data.aws_ami.ubuntu_ami.id
  instance_type     = "t2.micro"
  key_name    = var.key_name
  vpc_security_group_ids = [var.security_id]
  availability_zone = data.aws_availability_zones.zone_east.names[count.index]
  count             = var.instances
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

  provisioner "file" {
    source      = "requirements.txt"
    destination = "/home/ubuntu"
  }

  provisioner "file" {
    source      = "CaseApp-*.tar.gz"
    destination = "/home/ubuntu"
  }

  provisioner "file" {
    source      = "AWS_WSGI.service"
    destination = "/home/ubuntu"
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 20",
      "python3 --version",
      "sudo apt-get update",
      "sudo apt-get install python3-wheel build-essential python3-dev python3-pip -y",
      "sudo ufw allow 9090",
      "export PATH=$PATH:/home/ubuntu/.local/bin",
      "pip3 install -r requirements.txt",
      "tar -xzf CaseApp-*.tar.gz",      
      "sudo cp AWS_WSGI.service /etc/systemd/system/",
      "sudo systemctl daemon-reload",
      "sudo systemctl start AWS_WSGI.service",
      "sudo systemctl enable AWS_WSGI.service"
    ]
  }
}

resource "aws_lb" "ELB_CaseApp" {
  name               = "ELBCaseApp"
  load_balancer_type = "application"
  internal           = false
  security_groups    = data.aws_security_groups.ELB.ids
  subnets            = data.aws_subnet_ids.subnets.ids
  tags = {
    Name = "ELBCaseApp"
  }
  depends_on = [aws_instance.backend]
}

resource "aws_lb_target_group" "backbendCase-lb-tg" {
  name     = "backbendCase-lb-tg"
  port     = 9090
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.selected.id
  depends_on = [aws_lb.ELB_CaseApp]
}

resource "aws_lb_target_group_attachment" "backend_attachment" {

  count = length(aws_instance.backend)
  target_group_arn = aws_lb_target_group.backbendCase-lb-tg.arn
  target_id        = aws_instance.backend[count.index].id
  depends_on = [aws_lb_target_group.backbendCase-lb-tg]
}
resource "aws_lb_listener" "LB_listener" {
  load_balancer_arn = aws_lb.ELB_CaseApp.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backbendCase-lb-tg.arn
  }
  depends_on = [aws_lb_target_group_attachment.backend_attachment]
}