provider "aws" {
  region = "us-east-1"  # Change to your region
}
 
# -------------------------------
# Create S3 Bucket for State File
# -------------------------------
# resource "aws_s3_bucket" "terraform_state_bucket" {
#   bucket = "demo-bucket-anushka26"     # Change to a unique name
#   acl    = "private"
 
#   versioning {
#     enabled = true
#   }
 
#   tags = {
#     Name        = "TerraformStateBucket"
#     Environment = "Dev"
#   }
# }
 
# -------------------------------
# Configure S3 Backend for State
# -------------------------------
terraform {
  backend "s3" {
    bucket         = "demo-bucket-anushka26"   # Should match the bucket above
    key            = "terraform.tfstate"
    region         = "us-east-1"
  }
}
 
# -------------------------------
# Create EC2 Instance
# -------------------------------

data "aws_vpc" "existing_vpc" {
    id = "vpc-0f6f406e1dfc0edf8"
}

data "aws_subnet" "existing_subnets" {
    filter {
      name = "vpc-id"
      values = [data.aws_vpc.existing_vpc.id]
    }
    filter {
      name = "availability-zone"
      values = [ "us-east-1a" ]
    }
}


resource "aws_instance" "node_app" {
  ami           = "ami-0f88e80871fd81e91"  # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  subnet_id = data.aws_subnet.existing_subnets.id
  associate_public_ip_address = true

  
  tags = {
    Name = "NodeAppInstance"
  }

  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = file("C:/Users/AAJITJAD/Downloads/demo-key-pair.pem")
    host = self.public_ip
  }
 
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y nodejs npm",
      "node -v && npm -v",

      # Jenkins Installation
      "sudo yum install -y java-11-openjdk",
      "sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo",
      "sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key",
      "sudo yum install -y jenkins",
      "sudo systemctl start jenkins",
      "sudo systemctl enable jenkins",
      
      # Open Jenkins port
      "sudo firewall-cmd --permanent --zone=public --add-port=8080/tcp",
      "sudo firewall-cmd --reload"
    ]
  }
}
 