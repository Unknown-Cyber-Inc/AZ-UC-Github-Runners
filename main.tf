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
  for_each            = toset(["infra","cust"])
  name                = var.az_acg_name
  location            = data.azurerm_resource_group.ucgithubrunnerrg.location
  resource_group_name = data.azurerm_resource_group.ucgithubrunnerrg.name
  ip_address_type     = "Private"
  subnet_ids          = [data.azurerm_subnet.ucgithubrunnersubnet.id]
  os_type             = "Linux"

  container {
    name   = join("-",["az-into365exch",each.key,"github-runner"])
    image  = var.aci_docker_image
    cpu    = "0.5"
    memory = "1.5"
    environment_variables = {
        "RUNNER_NAME"  = join("-",["az-into365exch",each.key,"github-runner"])
        "RUNNER_TOKEN" = var.az_into365exch_infra_github_runner_token
        "ORG_NAME"     = var.gh_runner_org_name
        "RUNNER_GROUP" = var.gh_runner_group_name
        "RUNNER_SCOPE" = var.gh_runner_scope
        "LABELS"       = each.key
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