provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "openttd" {
  ami                         = "ami-0932440befd74cdba"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.instance.id]
  key_name                    = "uber"
  associate_public_ip_address = true

  tags = {
    Name = "Openttd testing"
  }

  connection {
    type        = "ssh"
    host        = aws_instance.openttd.public_ip
    user        = "ubuntu"
    port        = 22
    agent       = true
    private_key = file("/home/ubersholder/uber.pem")
  }

  provisioner "file" {
    source      = "/home/ubersholder/openttd/openttd.sh"
    destination = "/tmp/openttd.sh"
  }
  provisioner "file" {
    source      = "/home/ubersholder/openttd/openttd.cfg"
    destination = "/tmp/openttd.cfg"
  }
  provisioner "remote-exec" {
    inline = [
      "sleep 40",
      "sudo chmod +x /tmp/openttd.sh",
      "cd /tmp",
      "./openttd.sh"
    ]
  }
}

#  user_data = <<EOF
#        #!/bin/bash
#        sudo apt update
#        sudo apt upgrade
#        sudo apt-get build-dep openttd
#        wget https://cdn.openttd.org/openttd-releases/1.10.3/openttd-1.10.3-linux-ubuntu-focal-amd64.deb
#        sudo dpkg -i openttd-1.10.3-linux-ubuntu-focal-amd64.deb
#        openttd -D
#          EOF  
#  tags = {
#    Name = "openttd IAC"
#}
#}

resource "aws_security_group" "instance" {
  name        = "openttd SG"
  description = "SG for openttd with 3979 openned"
  ingress {
    from_port   = 3979
    to_port     = 3979
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3979
    to_port     = 3979
    protocol    = "UDP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3978
    to_port     = 3978
    protocol    = "UDP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

