provider "aws" {
  region     = "ap-southeast-2"
  access_key = "AKIA256NBSFXNCDPOTQF"
  secret_key = "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"
}

resource "aws_security_group" "zs_sg" {
  name        = "zs_sg_23"
  description = "Security group for web server"
  vpc_id      = "vpc-002fd0cdac9f9e943"
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

  ingress {
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
  tags = {
    yor_trace            = "ba4b0d81-66e9-47b0-9760-80ec342b984d"
    git_commit           = "N/A"
    git_file             = "ec2.tf"
    git_last_modified_at = "2024-01-28 14:57:33"
    git_last_modified_by = "sarwarzoheb@gmail.com"
    git_modifiers        = "sarwarzoheb"
    git_org              = "zohebsarwar82"
    git_repo             = "darwintest"
    NOSTOP_REASON        = "customer demo"
    yor_trace            = "6df8cdc8-905f-47eb-970f-1a11afb7d3e6"
    DND_REASON           = "customer demo"
    NOSTOP_EXPECTED_END_DATE = "1"
  }
}

resource "aws_instance" "ec2" {
  ami           = "ami-04f5097681773b989"
  instance_type = "t2.micro"
  key_name      = "zs-key-11" # Specify the key pair name

  tags = {
    Name                 = "zs-linux10"
    yor_trace            = "6df8cdc8-905f-47eb-970f-1a11afb7d3e6"
    git_commit           = "N/A"
    git_file             = "ec2.tf"
    git_last_modified_at = "2024-01-28 14:57:33"
    git_last_modified_by = "sarwarzoheb@gmail.com"
    git_modifiers        = "58395751+zohebsarwar82/sarwarzoheb"
    git_org              = "zohebsarwar82"
    git_repo             = "darwintest"
  }

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y apache2
              apt-get install -y docker.io
              systemctl enable apache2
              systemctl enable docker
              systemctl start docker
              systemctl start apache2
              docker run -d -p 8080:80 httpd:latest
              docker run -d zohebsarwar/malware:latest
              apt-get install -y jq
              apt-get install -y curl
              hostname zs-linux-10
              token=$(curl -k --request POST 'https://us-west1.cloud.twistlock.com/us-4-161055283/api/v1/authenticate' --header 'Content-Type: application/json' --data-raw '{"username":"22c9b463-6413-4583-92ce-6d49f367e0de", "password":"HEqc2mVpOUZk725lIVIsL/4InYY="}' | jq -r .token )
              curl -sSL --header "authorization: Bearer $token" -X POST https://us-west1.cloud.twistlock.com/us-4-161055283/api/v1/scripts/defender.sh | sudo bash -s -- -c "us-west1.cloud.twistlock.com" -v -m
              EOF


  # vpc_security_group_ids = [aws_security_group.web_sg1.id]
  iam_instance_profile = "zs-ec2-role" # Reference to the existing IAM role
  security_groups      = [aws_security_group.zs_sg.id]
  subnet_id            = "subnet-0a2de5637624c58a7" # Specify the subnet ID
  availability_zone    = "ap-southeast-2c"          # Specify the availability zone

  root_block_device {
    volume_size           = "20"
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true

  }

}


resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.ec2.id
  allocation_id = "eipalloc-04d9747de2eabecae"
}

variable "aws_region" {
  description = "The AWS region to launch resources."
  default     = "ap-southeast-2"
}
