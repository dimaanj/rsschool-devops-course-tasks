resource "aws_key_pair" "bastion-ssh-key" {
  key_name   = "bastion-ssh-key"
  public_key = data.terraform_remote_state.init_state.outputs.public_key
}

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

resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "ssm_instance_profile"
  role = aws_iam_role.ssm_role.name
}

resource "aws_instance" "private" {
  ami                         = var.ami
  instance_type               = var.type
  subnet_id                   = aws_subnet.private_a.id
  vpc_security_group_ids      = [aws_security_group.private_sg.id]
  associate_public_ip_address = false
  key_name                    = aws_key_pair.bastion-ssh-key.key_name

  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile.name

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
