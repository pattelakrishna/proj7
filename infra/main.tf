terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.30.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = "d6e154dc-0c67-4143-9261-e8b06141c24f"
  tenant_id       = "e8e808be-1f06-40a2-87f1-d3a52b7ce684"
  client_id       = "038c6474-ab85-462d-967c-7fe666cd99e7"
  client_secret   = "85098fdc-8214-43d1-b568-69767385204e"
}

resource "azurerm_service_plan" "plan" {
  name                = "kimi-service-plan"
  location            = "canadacentral"
  resource_group_name = "project7"
  os_type             = "Linux"
  sku_name            = "S1"
}

resource "azurerm_linux_web_app" "web" {
  name                = "kimi-web-app-jenkins-3"
  location            = "canadacentral"
  resource_group_name = "project7"
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
    application_stack {
      java_server         = "JAVA"
      java_version        = "17"
      java_server_version = "17"
    }
  }
}
