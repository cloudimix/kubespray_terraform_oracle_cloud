resource "oci_core_internet_gateway" "MainIGW" {
  compartment_id = var.compartment_ocid
  display_name   = "MainIGW"
  enabled        = "true"
  vcn_id         = oci_core_vcn.MainVCN.id
}

resource "oci_core_subnet" "Public_subnet" {

  cidr_block                 = "10.0.0.0/17"
  compartment_id             = var.compartment_ocid
  display_name               = "Public_subnet"
  dns_label                  = "publicsubnet"
  prohibit_internet_ingress  = "false"
  prohibit_public_ip_on_vnic = "false"
  route_table_id             = oci_core_vcn.MainVCN.default_route_table_id
  security_list_ids = [
    oci_core_vcn.MainVCN.default_security_list_id,
  ]
  vcn_id = oci_core_vcn.MainVCN.id
}

resource "oci_core_vcn" "MainVCN" {

  cidr_blocks = [
    "10.0.0.0/16",
  ]
  compartment_id = var.compartment_ocid
  display_name   = "MainVCN"
  dns_label      = "mainvcn"
}

resource "oci_core_default_dhcp_options" "Default-DHCP-Options-for-MainVCN" {
  compartment_id             = var.compartment_ocid
  display_name               = "Default DHCP Options for MainVCN"
  domain_name_type           = "CUSTOM_DOMAIN"
  manage_default_resource_id = oci_core_vcn.MainVCN.default_dhcp_options_id
  options {
    server_type = "VcnLocalPlusInternet"
    type        = "DomainNameServer"
  }
  options {
    search_domain_names = [
      "publicsubnet.mainvcn.oraclevcn.com",
    ]
    type = "SearchDomain"
  }
}

resource "oci_core_default_route_table" "Route-Table-for-MainVCN" {
  compartment_id             = var.compartment_ocid
  display_name               = "Route Table for MainVCN"
  manage_default_resource_id = oci_core_vcn.MainVCN.default_route_table_id
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.MainIGW.id
  }
}

resource "oci_core_default_security_list" "Security-List-for-MainVCN" {
  compartment_id = var.compartment_ocid
  display_name   = "Security List for MainVCN"
  egress_security_rules {
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
    stateless        = "false"
  }
  ingress_security_rules {
    icmp_options {
      code = "0"
      type = "8"
    }
    protocol    = "1"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
  }
  ingress_security_rules {
    description = "https"
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    tcp_options {
      max = "443"
      min = "443"
    }
  }
  ingress_security_rules {
    description = "http"
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    tcp_options {
      max = "80"
      min = "80"
    }
  }
  ingress_security_rules {
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    tcp_options {
      max = "22"
      min = "22"
    }
  }
  ingress_security_rules {
    description = "kube"
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    tcp_options {
      max = "6443"
      min = "6443"
    }
  }
  ingress_security_rules {
    description = "kube"
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    tcp_options {
      max = "2380"
      min = "2379"
    }
  }
  ingress_security_rules {
    description = "kube"
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    tcp_options {
      max = "32767"
      min = "30000"
    }
  }
  ingress_security_rules {
    description = "kube"
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    tcp_options {
      max = "10260"
      min = "10250"
    }
  }
  ingress_security_rules {
    description = "kube"
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    tcp_options {
      max = "8443"
      min = "8443"
    }
  }
  ingress_security_rules {
    description = "https"
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    tcp_options {
      max = "8081"
      min = "8080"
    }
  }
  manage_default_resource_id = oci_core_vcn.MainVCN.default_security_list_id
}
