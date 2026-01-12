# Create Key Pair in AWS
resource "aws_key_pair" "my_key" {
  key_name   = "terraform-key"
  public_key = file("terraform-key1.pub")
}

# Security Group (Allow SSH)
resource "aws_security_group" "ssh_sg" {
  name = "allow-ssh"

  ingress {
    from_port   = 22
    to_port     = 22
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

# EC2 Instance 
resource "aws_instance" "my_ec2" {
  ami                    = "ami-0ecb62995f68bb549"   # Amazon Linux 2 (Mumbai)
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.my_key.key_name
  vpc_security_group_ids = [aws_security_group.ssh_sg.id]

  tags = {
    Name = "Terraform-EC2-SSH"
  }
}
