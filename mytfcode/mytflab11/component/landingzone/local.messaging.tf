locals {
  messaging = merge(
    var.messaging,
    {
      signalr_services      = var.signalr_services
      servicebus_namespaces = var.servicebus_namespaces
      servicebus_topics     = var.servicebus_topics
      servicebus_queues     = var.servicebus_queues
      eventgrid_domain             = var.eventgrid_domain
      eventgrid_topic              = var.eventgrid_topic
      eventgrid_event_subscription = var.eventgrid_event_subscription
      eventgrid_domain_topic       = var.eventgrid_domain_topic
      web_pubsubs                  = var.web_pubsubs
      web_pubsub_hubs              = var.web_pubsub_hubs
    }
  )
}
