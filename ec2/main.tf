resource "aws_instance" "kops-bootstrapper" {
  ami                    = "${var.API_INSTANCE_AMI}"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.example.id]
  key_name               = var.key_pair_name

  # This EC2 Instance has a public IP and will be accessible directly from the public Internet
  associate_public_ip_address = true

  tags = {
    Name = "kops-bootstrapper"
  }
}

resource "null_resource" "remote_provisioner" {
  triggers = {
    public_ip = aws_instance.kops-bootstrapper.public_ip
  }

  connection {
    type  = "ssh"
    host  = aws_instance.kops-bootstrapper.public_ip
    user  = "ec2-user"
    port  = "22"
    agent = true
  }

  provisioner "file" {
    source      = "terraform-kops/*"
    destination = "/usr/local/bin"
  }
