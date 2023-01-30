resource "azurerm_application_gateway" "terra-app" {
  name                = "Appgateway"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "Appgateway-ip-configuration"
    subnet_id = azurerm_subnet.my_appgateway_subnet.frontend.id
  }

  frontend_port {
    name = "http_port"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "Myhttp_pubip"
    public_ip_address_id = azurerm_public_ip.frondendpublicip.id
  }

  backend_address_pool {
    name = "Backend_pool"
  }

  backend_http_settings {
    name                  = "myHTTPsetting"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = "myListener"
    frontend_ip_configuration_name = "Myhttp_pubip"
    frontend_port_name             = "http_port"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "myRoutingRule"
    rule_type                  = "Basic"
    http_listener_name         = "myListener"
    backend_address_pool_name  = "Backend_pool"
    backend_http_settings_name = "myHTTPsetting"
  }
}