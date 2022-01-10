output "id" {
  value = random_password.this.id
}


// This should not be exported to state file. Instead, it should be consumed in the same execution instance by another module.
# output "result"{
#     value = random_password.this.result
#     sensitive = true
# }