# Store output attributes into keyvault secret
dynamic_keyvault_secrets = {
  adds_keyvault = { # Key of the keyvault
    vmadmin-username = {
      secret_name = "vmadmin-username"
      value       = "vmadmin"
    }
    vmadmin-password = {
      secret_name = "vmadmin-password"
      value       = "Very@Str5ngP!44w0rdToChaNge#"
    }
    domain-join-username = {
      secret_name = "domain-join-username"
      value       = "domainjoinuser@contoso.com"
    }
    domain-join-password = {
      secret_name = "domain-join-password"
      value       = "MyDoma1nVery@Str5ngP!44w0rdToChaNge#"
    }
  }
}