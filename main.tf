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
    resource_group_name  = "virusbattle-gitlab-runners"
    storage_account_name = "ucgithubrunners"
    container_name       = "ucgithubrunners-tfstate" # container must exist
    key                  = "ucgithubrunners.terraform.tfstate"
  }
}

#Resource Group For Containers
data "azurerm_resource_group" "ucgithubrunnerrg" {
  name = var.az_resource_group
}

#Data About Github Runners Subnet
data "azurerm_subnet" "ucgithubrunnersubnet" {
  name                 = var.az_subnet_name
  virtual_network_name = var.az_virtual_network_name
  resource_group_name  = var.az_resource_group
}

resource "azurerm_container_app_environment" "ucacaenv" {
  name                       = var.az_container_app_environment
  location                   = data.azurerm_resource_group.ucgithubrunnerrg.location
  resource_group_name        = data.azurerm_resource_group.ucgithubrunnerrg.name
}

resource "azurerm_container_app" "ucaca" {
  for_each                     = var.ghrunners
  name                         = join("-",["into365exch",each.key,"ghr"])
  container_app_environment_id = azurerm_container_app_environment.ucacaenv.id
  resource_group_name          = data.azurerm_resource_group.ucgithubrunnerrg.name
  revision_mode                = "Single"

  template {
    container {
      name   = join("-",["into365exch",each.key,"ghr"])
      image  = var.aci_docker_image
      cpu    = 0.25
      memory = "0.5Gi"
      env {
        name = "RUNNER_NAME"
        value = join("-",["into365exch",each.key,"ghr"])
      }  
      env {
        name = "ACCESS_TOKEN"
        value = var.access_token
      }
      env {
        name = "RUNNER_GROUP"
        value = var.gh_runner_group_name
      }
      env {
        name = "LABELS"
        value = each.key
      }
      env {
        name = "RUNNER_SCOPE"
        value = var.gh_runner_scope
      }
      env {
        name = "ORG_NAME"
        value = var.gh_runner_org_name
      }
      env {
        name = "DISABLE_AUTO_UPDATE"
        value = "true"
      }
    }
  }
}
