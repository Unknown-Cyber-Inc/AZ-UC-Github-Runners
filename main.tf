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
  resource_group_name  = var.ghrsubnetrg
}

data "azurerm_log_analytics_workspace" "ucintlaw"{
  name                = var.az_law_name
  resource_group_name = var.az_law_rg_name
}

#Setup Containers To Create Here
locals {
  containers = {
    infra = {
      ports = {
        https = {
          port     = 443 #Assign Different Port Per Container - TF requires even though we're not using
          protocol = "TCP"
        }
      }
    }

    cust = {
      ports = {
        https = {
          port     = 444 #Assign Different Port Per Container - TF requires even though we're not using
          protocol = "TCP"
        }
      }
    }
  }

  #Setup A Map Of Environment Variables For The Containers
  env_vars = {
    ACCESS_TOKEN        : var.access_token
    RUNNER_GROUP        : var.gh_runner_group_name
    RUNNER_SCOPE        : var.gh_runner_scope
    ORG_NAME            : var.gh_runner_org_name
    DISABLE_AUTO_UPDATE : "true"
  }
   
}

resource "azurerm_container_group" "ucacg" {
  name                = var.az_acg_name
  location            = data.azurerm_resource_group.ucgithubrunnerrg.location
  resource_group_name = data.azurerm_resource_group.ucgithubrunnerrg.name
  ip_address_type     = "Private"
  subnet_ids          = [data.azurerm_subnet.ucgithubrunnersubnet.id]
  os_type             = "Linux"
  
  image_registry_credential {
    username = "uccontainerregistry"
    server = "uccontainerregistry.azurecr.io"
    password = var.az_containerreg_password
  }
  
  dynamic "container" {
    for_each = local.containers

    content {
      name   = join("-",["into365exch",container.key,"ghr"])
      image  = var.aci_docker_image
      cpu    = 1.0
      memory = 2.0
      environment_variables = merge(local.env_vars,{LABELS:container.key},{RUNNER_NAME:join("-",["into365exch",container.key,"ghr"])})
      dynamic "ports" {
        for_each = can(container.value.ports) ? container.value.ports : {}

        content {
          port     = ports.value.port
          protocol = ports.value.protocol
        }

      }
    }
  }
  diagnostics {
    log_analytics {
      log_type = "ContainerInsights"
      workspace_id = data.azurerm_log_analytics_workspace.ucintlaw.workspace_id
      workspace_key = data.azurerm_log_analytics_workspace.ucintlaw.primary_shared_key
    }
  }
}

#resource "azurerm_log_analytics_workspace" "ucghrlaw" {
#  name                = "githubrunners-law"
#  location            = data.azurerm_resource_group.ucgithubrunnerrg.location
#  resource_group_name = data.azurerm_resource_group.ucgithubrunnerrg.name
#  sku                 = "PerGB2018"
#  retention_in_days   = 30
#}