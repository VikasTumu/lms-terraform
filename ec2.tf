# Web Server
resource "aws_instance" "lmds-web-server" {
    ami = "ami-010b74bc1a8b29122"
    instance_type = "t3.micro"
    subnet_id = aws_subnet.lms-web-sn.id
    key_name = "lms-key1"
    vpc_security_group_ids = [aws_security_group.lms-web-sg.id]
    region = "eu-north-1"
    tags = {
        Name = "lms-web-server"
    }
}

# API Server
resource "aws_instance" "lmds-api-server" {
    ami = "ami-010b74bc1a8b29122"
    instance_type = "t3.micro"
    subnet_id = aws_subnet.lms-api-sn.id
    key_name = "lms-key1"
    vpc_security_group_ids = [aws_security_group.lms-api-sg.id]
    region = "eu-north-1"
    tags = {
        Name = "lms-api-server"
    }
}

# DB server
resource "aws_instance" "lms-db-server" {
    ami = "ami-010b74bc1a8b29122"
    instance_type = "t3.micro"
    subnet_id = aws_subnet.lms-db-sn.id
    key_name = "lms-key1"
    vpc_security_group_ids = [aws_security_group.lms-db-sg.id]
    region = "eu-north-1"
    tags = {
        Name = "lms-db-server"
    }
}