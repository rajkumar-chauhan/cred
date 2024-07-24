#Redis

## Redis Security group

resource "aws_security_group" "redis_security_group" {
  vpc_id      = aws_vpc.ot_microservices_dev.id
  name        = "redis-security-group"
  description = "Security group for Redis instance"

  ingress {
    description    = "Allow SSH"
    from_port      = 22
    to_port        = 22
    protocol       = "tcp"
    security_groups = [aws_security_group.bastion_security_group.id]
  }

  ingress {
    description    = "Allow Redis"
    from_port      = 6379
    to_port        = 6379
    protocol       = "tcp"
    security_groups = [aws_security_group.attendance_security_group.id]
  }

  ingress {
    description    = "Allow Redis"
    from_port      = 6379
    to_port        = 6379
    protocol       = "tcp"
    security_groups = [aws_security_group.salary_security_group.id]
  }

  ingress {
    description    = "Allow Redis"
    from_port      = 6379
    to_port        = 6379
    protocol       = "tcp"
    security_groups = [aws_security_group.employee_security_group.id]
  }

    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "redis-security-group"
  }
}

## Redis instance 

resource "aws_instance" "Redis_instance" {
  # ami to be replaced with actual ami
  ami           = "ami-0862be96e41dcbf74"
  subnet_id = aws_subnet.database_subnet.id
  key_name = "backendp9"
  vpc_security_group_ids = [ aws_security_group.redis_security_group.id ]
  instance_type = "t2.micro"

  tags = {
    Name = "Redis"
  }
}



                                                                                                                                                   

