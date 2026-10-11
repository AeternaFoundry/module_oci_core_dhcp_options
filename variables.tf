variable "core_dhcp_options" {
  description = <<EOT
Map of core_dhcp_options, attributes below
Required:
    - compartment_id
    - vcn_id
    - options (block):
        - custom_dns_servers (optional)
        - search_domain_names (optional)
        - server_type (optional)
        - type (required)
Optional:
    - defined_tags
    - display_name
    - domain_name_type
    - freeform_tags
    - timeouts (block):
        - create (optional)
        - delete (optional)
        - update (optional)
EOT

  type = map(object({
    compartment_id   = string
    vcn_id           = string
    defined_tags     = optional(map(string))
    display_name     = optional(string)
    domain_name_type = optional(string)
    freeform_tags    = optional(map(string))
    options = list(object({
      custom_dns_servers  = optional(list(string))
      search_domain_names = optional(list(string))
      server_type         = optional(string)
      type                = string
    }))
    timeouts = optional(object({
      create = optional(string)
      delete = optional(string)
      update = optional(string)
    }))
  }))
  validation {
    condition = alltrue([
      for k, v in var.core_dhcp_options : (
        length(v.options) >= 1
      )
    ])
    error_message = "Each options list must contain at least 1 items"
  }
  validation {
    condition = alltrue([
      for k, v in var.core_dhcp_options : (
        alltrue([for item in v.options : (contains([for v in ["DomainNameServer", "SearchDomain"] : lower(v)], lower(item.type)))])
      )
    ])
    error_message = "must be one of: \"DomainNameServer\", \"SearchDomain\""
  }
  validation {
    condition = alltrue([
      for k, v in var.core_dhcp_options : (
        alltrue([for item in v.options : (item.server_type == null || (contains(["CustomDnsServer", "VcnLocal", "VcnLocalPlusInternet"], item.server_type)))])
      )
    ])
    error_message = "must be one of: \"CustomDnsServer\", \"VcnLocal\", \"VcnLocalPlusInternet\""
  }
}

