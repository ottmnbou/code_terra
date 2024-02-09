### Lancer une instance EC2
resource "aws_instance" "ottman_keypair" {
   ami = "ami-0a2e7efb4257c0907" 
   instance_type = "t2.micro"
   key_name      = "ottman_keypair"
   vpc_security_group_ids = [aws_security_group.instance_sg.id]
   user_data = <<-EOF
		#!/bin/bash
        sudo apt-get update
		    sudo apt-get install -y apache2
		    sudo systemctl start apache2
		    sudo systemctl enable apache2
		    sudo echo "<h1>Hello devopssec</h1>" > /var/www/html/index.html
	  EOF
   tags = { 
   Name = "test-ec2-terraform"
}
}

resource "aws_security_group" "instance_sg" {
    name = "ec2-sg-terraform-efrei"
    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}