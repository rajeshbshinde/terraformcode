provider "aws" {

  region     = "us-east-1"

  access_key = "AKIAQxxxxxxxxxxxD2E4Z"

  secret_key = "txrN1D4WxxxxxxxxxxxxCxtkJQmKAKP8MMPLhBxP/BcB"

}

resource "aws_security_group" "mysg" {
name        = "mysg"

  description = "Allow inbound SSH"



  ingress {

    from_port        = 22

    to_port          = 22

    protocol         = "tcp"

    cidr_blocks      = ["0.0.0.0/0"]

    ipv6_cidr_blocks = ["::/0"]

  }
ingress {

     description = "HTTP"

     from_port   = 8080

     to_port     = 8080

     protocol    = "tcp"

     cidr_blocks = ["0.0.0.0/0"]

   }

     egress {

     from_port   = 0

     to_port     = 0

     protocol    = "-1"

     cidr_blocks = ["0.0.0.0/0"]

   }

}

resource "aws_instance" "myec2" {

ami = "ami-0a699202e5027c10d"

instance_type = "t2.micro"

key_name = "web-keys"

tags = {

    Name = "RS-instance-1"

  }

 user_data = <<-EOF

      #!/bin/bash

        sudo yum install git -y

        sudo amazon-linux-extras install java-openjdk11 -y
         sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
       sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
      sudo yum install jenkins -y
       sudo systemctl start jenkins
 sudo yum install python3 -y

EOF


}

resource "aws_network_interface_sg_attachment" "sg_attachment1" {

security_group_id = aws_security_group.mysg.id

network_interface_id = aws_instance.myec2.primary_network_interface_id



}



