resource "oci_core_dhcp_options" "core_dhcp_options" {
  for_each = var.core_dhcp_options

  compartment_id   = each.value.compartment_id
  vcn_id           = each.value.vcn_id
  defined_tags     = each.value.defined_tags
  display_name     = each.value.display_name
  domain_name_type = each.value.domain_name_type
  freeform_tags    = each.value.freeform_tags

  dynamic "options" {
    for_each = each.value.options
    content {
      custom_dns_servers  = options.value.custom_dns_servers
      search_domain_names = options.value.search_domain_names
      server_type         = options.value.server_type
      type                = options.value.type
    }
  }

  dynamic "timeouts" {
    for_each = each.value.timeouts != null ? [each.value.timeouts] : []
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
      update = timeouts.value.update
    }
  }
}

