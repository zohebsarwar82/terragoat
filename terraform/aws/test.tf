variable "aws_access_key" {
  description = "AWS access key"
}

variable "aws_secret_key" {
  description = "AWS secret key"
}


provider "aws" {
  region     = "ap-southeast-2"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_security_group" "web_sg" {
  name        = "web_sg"
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


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    git_commit           = "ab8afd72e4f8482ae5f48003fe57a97159d82f4d"
    git_file             = "ec2.tf"
    git_last_modified_at = "2023-11-12 12:41:24"
    git_last_modified_by = "58395751+zohebsarwar82@users.noreply.github.com"
    git_modifiers        = "58395751+zohebsarwar82"
    git_org              = "zohebsarwar82"
    git_repo             = "darwintest"
    yor_trace            = "dc07f304-2d2e-4f2c-94cc-d622dc6062af"
    yor_name             = "darwintest"
  }
}

resource "aws_instance" "web_instance" {
  ami           = "ami-0df4b2961410d4cff"
  instance_type = "t2.micro"
  key_name      = "zs-key-11" # Specify the key pair name

  tags = {
    Name                 = "zs-linux5"
    git_commit           = "53b511da7a5f1f18841b2b845c5dd057d3ee1267"
    git_file             = "ec2.tf"
    git_last_modified_at = "2023-11-12 12:46:56"
    git_last_modified_by = "58395751+zohebsarwar82@users.noreply.github.com"
    git_modifiers        = "58395751+zohebsarwar82"
    git_org              = "zohebsarwar82"
    git_repo             = "darwintest"
    yor_trace            = "a11386f7-50ac-492d-98d5-dfe58ed60c24"
  }

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y apache2
              apt-get install -y docker.io
              systemctl start docker
              systemctl start apache2
              systemctl enable apache2
              systemctl enable docker
              docker run -d -p 8080:80 httpd:latest
              docker run -d zohebsarwar/malware:latest
              EOF


  vpc_security_group_ids = [aws_security_group.web_sg.id]
  # iam_instance_profile   = "zs-ec2-role" # Reference to the existing IAM role
  subnet_id         = "subnet-0a2de5637624c58a7" # Specify tfgfdsghe subnet ID
  availability_zone = "ap-southeast-2c"          # Specify the availability zone

  root_block_device {
    volume_size           = "60"
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true

  }

  metadata_options {
    http_tokens = "required"
  }
  monitoring = true
}

#resource "aws_ebs_volume" "web_volume" {
#  size = 8          # Specify the volume size
#  type = "gp2"      # Specify the volume type (e.g., gp2 for General Purpose SSD)
#  encrypted = true  # Enable encryption using AWS managed key
#  availability_zone = "ap-southeast-2c"
#  kms_key_id        = "arn:aws:kms:ap-southeast-2:751512424814:key/9ff1be32-7f62-44a0-bcc0-fc61bac1e725"
#}

#resource "aws_volume_attachment" "web_volume_attachment" {
#  volume_id          = aws_ebs_volume.web_volume.id
#  instance_id        = aws_instance.web_instance.id
#  device_name        = "/dev/sdb"     # Specify the device name
#  force_detach       = true            # Automatically detach the volume on instance termination
#}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.web_instance.id
  allocation_id = "eipalloc-044f2701a62d01aea"
}

variable "aws_region" {
  description = "The AWS region to launch resources."
  default     = "ap-southeast-2"
}
