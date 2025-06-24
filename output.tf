output "setup_ssh_agent" {
  value = "ssh-agent -s && ssh-add ${local.private_key_path}"
}

output "ssh_bastion" {
  value = "ssh -A -i \"${local.private_key_path}\" ec2-user@${aws_instance.bastion.public_ip}"
}

output "ssh_private_from_bastion" {
  value = "ssh ec2-user@${aws_instance.private.private_ip}"
}