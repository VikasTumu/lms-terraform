# Web Server
resource "aws_instance" "lms-web-server" {
    ami = "ami-010b74bc1a8b29122"
    instance_type = "t3.micro"
    subnet_id = aws_subnet.lms-web-sn.id
    key_name = "terrform"
    vpc_security_group_ids = [aws_security_group.lms-web-sg.id]
    tags = {
        Name = "lms-web-server"
    }
}

# API Server
resource "aws_instance" "lms-api-server" {
    ami = "ami-010b74bc1a8b29122"
    instance_type = "t3.micro"
    subnet_id = aws_subnet.lms-api-sn.id
    key_name = "terraform"
    vpc_security_group_ids = [aws_security_group.lms-api-sg.id]
    tags = {
        Name = "lms-api-server"
    }
}

# DB server
resource "aws_instance" "lms-db-server" {
    ami = "ami-010b74bc1a8b29122"
    instance_type = "t3.micro"
    subnet_id = aws_subnet.lms-db-sn.id
    key_name = "terraform"
    vpc_security_group_ids = [aws_security_group.lms-db-sg.id]
    tags = {
        Name = "lms-db-server"
    }
}