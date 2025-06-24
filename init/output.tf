output "public_key" {
  value = tls_private_key.rsa-4096-example.public_key_openssh
}
