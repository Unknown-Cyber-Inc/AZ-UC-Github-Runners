terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name  = "ucgithubrunnerrg"
    storage_account_name = "ucgithubrunners"
    container_name       = "ucgithubrunners-tfstate" # container must exist
    key                  = "ucgithubrunners.terraform.tfstate"
  }
}

data "azurerm_resource_group" "ucgithubrunnerrg" {
  name = "virusbattle-gitlab-runners"
}

data "azurerm_subnet" "ucgithubrunnersubnet" {
  name                 = "Github-runners"
  virtual_network_name = "production-vnet"
  resource_group_name  = "virusbattle-production"
}

resource "azurerm_container_group" "ucacg" {
  for_each            = var.containers
  name                = each.value.acg_name
  location            = data.azurerm_resource_group.ucgithubrunnerrg.location
  resource_group_name = data.azurerm_resource_group.ucgithubrunnerrg.name
  ip_address_type     = "Private"
  subnet_ids          = [data.azurerm_subnet.ucgithubrunnersubnet.id]
  os_type             = "Linux"

  container {
    name   = each.value.runner_name
    image  = each.value.docker_image
    cpu    = "0.5"
    memory = "1.5"
    environment_variables = {
        "RUNNER_NAME"  = each.value.runner_name
        "RUNNER_TOKEN" = each.key == "core" ? var.az_uc_core_infra_runner_token : var.az_uc_cust_infra_runner_token
        "ORG_NAME"     = "Unknown-Cyber-Inc"
        "REPO_URL"     = each.value.repo_url
    }
  
    ports {
      port     = 443
      protocol = "TCP"
    }
  }
  tags = {
    environment = "testing"
  }
}