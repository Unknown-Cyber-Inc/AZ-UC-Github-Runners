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


resource "azurerm_container_app_environment" "ucacaenv" {
  name                       = "into365-aca-env"
  location                   = data.azurerm_resource_group.ucgithubrunnerrg.location
  resource_group_name        = data.azurerm_resource_group.ucgithubrunnerrg.name
}

resource "azurerm_container_app" "ucaca" {
  for_each                     = toset(["infra","cust"])
  name                         = join("-",["az-into365exch",each.key,"github-runner"])
  container_app_environment_id = azurerm_container_app_environment.ucacaenv.id
  resource_group_name          = data.azurerm_resource_group.ucgithubrunnerrg.name
  revision_mode                = "Single"

  template {
    container {
      name   = join("-",["az-into365exch",each.key,"github-runner"])
      image  = var.aci_docker_image
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }
}