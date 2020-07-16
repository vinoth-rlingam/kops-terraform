resource "aws_instance" "kops-bootstrapper" {
  ami                    = "${var.API_INSTANCE_AMI}"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ec2-sg.id]


  # This EC2 Instance has a public IP and will be accessible directly from the public Internet
  associate_public_ip_address = true

  tags = {
    Name = "kops-bootstrapper"
  }

   provisioner "remote-exec" {

    inline = [
      "cd /home/ec2-user/terraform-kops",
      "chmod +x run.bash",
      "./run.bash ap-southeast remote-terraform-kops-state"
    ]
    connection {
    type  = "ssh"
    host  = self.public_ip
    user  = "ec2-user"
    port  = "22"
    private_key = "${file("./kopsterraform.pem")}"
  }

  }
}

resource "aws_security_group" "ec2-sg" {
  name = "kops-bootstrapper-sg"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    # To keep this example simple, we allow incoming SSH requests from any IP. In real-world usage, you should only
    # allow SSH requests from trusted servers, such as a bastion host or VPN server.
    cidr_blocks = ["0.0.0.0/0"]

  }
}







