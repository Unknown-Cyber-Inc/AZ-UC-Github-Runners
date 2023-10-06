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
