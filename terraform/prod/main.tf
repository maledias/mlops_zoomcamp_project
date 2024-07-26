# Configure required_providers
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create VPC
resource "aws_vpc" "mlops_zc_vpc" {
    cidr_block = "10.0.0.0/24"

    tags = {
        name ="mlops-zoomcamp-proj-vpc"
    }
}

# Create internet gateway
resource "aws_internet_gateway" "mlops_zc_IG" {
    vpc_id = aws_vpc.mlops_zc_vpc.id

    tags = {
        Name = "mlops-zoomcamp-proj-IG"
    }
}

# Create subnet
resource "aws_subnet" "mlops_zc_public_subnet" {
    
    vpc_id = aws_vpc.mlops_zc_vpc.id
    cidr_block = "10.0.0.0/24"
    depends_on = [aws_internet_gateway.mlops_zc_IG]
    map_public_ip_on_launch = true

    tags = {
        Name = "mlops-zoomcamp-proj-pub-subnet"
    }
}

# Create Route Table
resource "aws_route_table" "mlops_zc_route_table" {

    vpc_id = aws_vpc.mlops_zc_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.mlops_zc_IG.id
    }

    route {
        cidr_block = "10.0.0.0/24"
        gateway_id = "local"
    }

    tags = {
        Name = "mlops-zoomcamp-proj-route-table"
    }

}

# Associate Subnet with Route Table
resource "aws_route_table_association" "RT_to_Subnet" {

    subnet_id = aws_subnet.mlops_zc_public_subnet.id
    route_table_id = aws_route_table.mlops_zc_route_table.id

}


# Create a Security Group to Allow ports : 22
resource "aws_security_group" "mlops_zc_sc" {

    name = "mlops-zoomcamp-security-group"
    description = "Allow SSH inbound traffic"
    vpc_id = aws_vpc.mlops_zc_vpc.id

    ingress {
        description = "SSH from anywhere"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "mlops-zoomcamp-security-group"
    }
}



















































































