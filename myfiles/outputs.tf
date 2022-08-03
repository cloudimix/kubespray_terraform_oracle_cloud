output "ARM_Master_public_ip" {
  value = oci_core_instance.instance-master[*].public_ip
}
output "ARM_Node_public_ip" {
  value = oci_core_instance.instance-node[*].public_ip
}
output "ARM_Master_private_ip" {
  value = oci_core_instance.instance-master[*].private_ip
}
output "ARM_Node_private_ip" {
  value = oci_core_instance.instance-node[*].private_ip
}
