output "terraform_remote_state_output" {
  value = var.resource_tag == null ? data.terraform_remote_state.this.outputs : data.terraform_remote_state.this.outputs[var.resource_tag]
}