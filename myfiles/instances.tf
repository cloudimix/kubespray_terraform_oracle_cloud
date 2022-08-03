resource "oci_core_instance" "instance-master" {
  count = var.master_count
  agent_config {
    are_all_plugins_disabled = "false"
    is_management_disabled   = "false"
    is_monitoring_disabled   = "false"
    plugins_config {
      desired_state = "DISABLED"
      name          = "Vulnerability Scanning"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Compute Instance Monitoring"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Bastion"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Block Volume Management"
    }
  }
  availability_config {
    recovery_action = "RESTORE_INSTANCE"
  }
  availability_domain = data.oci_identity_availability_domain.oVBc-EU-FRANKFURT-1-AD-2.name
  compartment_id      = var.compartment_ocid
  display_name        = format("instance-master%02d", count.index + 1)
  fault_domain        = "FAULT-DOMAIN-1"
  instance_options {
    are_legacy_imds_endpoints_disabled = "false"
  }
  create_vnic_details {
    private_ip       = format("10.0.1.%d", count.index + 1)
    assign_public_ip = var.public_ip_enabled
    subnet_id        = oci_core_subnet.Public_subnet.id
  }
  launch_options {
    boot_volume_type                    = "PARAVIRTUALIZED"
    firmware                            = "UEFI_64"
    is_consistent_volume_naming_enabled = "true"
    network_type                        = "PARAVIRTUALIZED"
    remote_data_volume_type             = "PARAVIRTUALIZED"
  }
  metadata = {
    "ssh_authorized_keys" = file(var.id_rsa_pub)
  }
  shape = "VM.Standard.A1.Flex"
  shape_config {
    memory_in_gbs = "12"
    ocpus         = "2"
  }
  source_details {
    boot_volume_size_in_gbs = "50"
    boot_volume_vpus_per_gb = "10"
    source_id               = var.instance-ARM_source_image_id
    source_type             = "image"
  }
  state = "RUNNING"
}

resource "oci_core_instance" "instance-node" {
  count = var.node_count
  agent_config {
    are_all_plugins_disabled = "false"
    is_management_disabled   = "false"
    is_monitoring_disabled   = "false"
    plugins_config {
      desired_state = "DISABLED"
      name          = "Vulnerability Scanning"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Compute Instance Monitoring"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Bastion"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Block Volume Management"
    }
  }
  availability_config {
    recovery_action = "RESTORE_INSTANCE"
  }

  availability_domain = data.oci_identity_availability_domain.oVBc-EU-FRANKFURT-1-AD-2.name
  compartment_id      = var.compartment_ocid
  display_name        = format("instance-node%02d", count.index + 1)
  fault_domain        = "FAULT-DOMAIN-1"
  instance_options {
    are_legacy_imds_endpoints_disabled = "false"
  }
  create_vnic_details {
    private_ip       = format("10.0.2.%d", count.index + 1)
    assign_public_ip = var.public_ip_enabled
    subnet_id        = oci_core_subnet.Public_subnet.id
  }
  launch_options {
    boot_volume_type                    = "PARAVIRTUALIZED"
    firmware                            = "UEFI_64"
    is_consistent_volume_naming_enabled = "true"
    network_type                        = "PARAVIRTUALIZED"
    remote_data_volume_type             = "PARAVIRTUALIZED"
  }
  metadata = {
    "ssh_authorized_keys" = file(var.id_rsa_pub)
  }
  shape = "VM.Standard.A1.Flex"
  shape_config {
    memory_in_gbs = "6"
    ocpus         = "1"
  }
  source_details {
    boot_volume_size_in_gbs = "50"
    boot_volume_vpus_per_gb = "10"
    source_id               = var.instance-ARM_source_image_id
    source_type             = "image"
  }
  state = "RUNNING"
}
