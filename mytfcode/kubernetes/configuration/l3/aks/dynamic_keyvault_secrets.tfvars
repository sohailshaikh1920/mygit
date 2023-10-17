dynamic_keyvault_secrets = {

  # Jumpbox Keyvault Secrets

  aks_jumpbox = { # Key of the keyvault
    admin_public_ssh_key = {
      secret_name = "ssh-key"
      value       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDpTPg902uyF9QmsTxvFwNpWaIQhrm8nWE3H1sumL0MXOP2fa8Ld+d8fJUunHHyXFLqxUuGYeYTcQTt5Uez5iRTF88zngbltgHr7LABBVwZQR0MVZUL4lLqLrx4b0HJFThf4NaAk7ZpQt70Qe/3ljBt55Tzhiz3py2Tr2vx0JIqsRR91t4NUHztqCWl5ZzGc2hb7ZEz80y+F4emYfWBBDY2HjgMWBIk8ZEsiW58Nf5akmCDYBdAE5XPaCZVnMOaiXM+jQH62JzRlmBDQ0yDPcVU05qqz0XKOotY1RZfwx8jztuBVp5CUOF4sKhJtInZnHuQSGIWPJZqSjLmhGrtXCOI+U/LmKS3fb00EIpM6PWWQwJcy8fLP3DaNR7FjRCFEfGxYu/pQczq7ihUXwJ5kVZaEB62dgs7oSIi5kgt+YxXAv3jjoauBG/DHgrZTmuf4TscLHsjA+p2Koux+8WdbjbYUy5OdDlCjggQLzal/70o/OLs/EPDxECi2c88RwUDPH7/KtVqJ46QHB5xuN0MgWO1h4kLilOkZ1B1YyPjDufKW96b27PjkFMmV1dq5wM+ybvL2kTNONL5svZUpQWAhtQMNy0DSnmbCM5jCzN60kiDg5CQzYNZSjeXZiamTsMMfzUmPcMSz0PfOAgmgYEdVWBKCIQVDsH9ua7oiP+MpdzxzQ=="
    }
    vmadmin-username = {
      secret_name = "vmadmin-username"
      value       = "vmadmin"
    }
    vmadmin-password = {
      secret_name = "vmadmin-password"
      value       = "Very@Str5ngP!44w0rdToChaNge#"
    }
  }
  
}
