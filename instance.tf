resource "aws_instance" "bastion" {
  ami                         = var.ami
  instance_type               = var.type
  subnet_id                   = aws_subnet.public_a.id
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.bastion-ssh-key.key_name
  tags = {
    Name = "Bastion Host"
  }
}

resource "aws_instance" "private" {
  ami                         = var.ami
  instance_type               = var.type
  subnet_id                   = aws_subnet.private_a.id
  vpc_security_group_ids      = [aws_security_group.private_sg.id]
  associate_public_ip_address = false
  key_name                    = aws_key_pair.bastion-ssh-key.key_name
  tags = {
    Name = "Private Instance"
  }
} 

resource "aws_instance" "demo" {
  ami           = var.ami
  instance_type = var.type

  tags = {
    name = "My VM"
  }

  lifecycle {
    prevent_destroy = false
  }
} 
