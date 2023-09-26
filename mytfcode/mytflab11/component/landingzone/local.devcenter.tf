locals {
  devcenter = merge(
    var.devcenter,
    {
      network_connections        = var.network_connections
    }
  )
}