provider "aws" {
  region = var.region
}

// import state file with public key from init local folder
data "terraform_remote_state" "init_state" {
  backend = "local"

  config = {
    path = local.init_tf_state_path
  }
}

resource "aws_key_pair" "bastion-ssh-key" {
  key_name   = "bastion-ssh-key"
  public_key = data.terraform_remote_state.init_state.outputs.public_key
}
