terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.9.0"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "example" {
  name = "virusbattle-gitlab-runners"
}

data "azurerm_subnet" "example" {
  name                 = "Github-runners"
  virtual_network_name = "production-vnet"
  resource_group_name  = data.azurerm_resource_group.example.name
}

resource "azurerm_container_group" "example" {
  name                = "aci-uc-github-runners"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name
  ip_address_type     = "Private"
  subnet_ids          = data.azurerm_subnet.example.id
  os_type             = "Linux"

  
  container {
    name   = "uc-coreinfra-github-runner"
    image  = "myoung34/github-runner"
    cpu    = "0.5"
    memory = "1.5"
    environment_variables = {
        "RUNNER_NAME"  = uc-core-github-runner
        "RUNNER_TOKEN" = BBSWHMUUHIZNF2OWIHYRA6DE5VLLM
        "ORG_NAME"     = Unknown-Cyber-Inc
        "REPO_URL"     = "https://github.com/Unknown-Cyber-Inc/AZ-UC-Core-Infra"
    }
  
    ports {
      port     = 443
      protocol = "TCP"
    }
  }

  container {
    name   = "uc-custinfra-github-runner"
    image  = "myoung34/github-runner"
    cpu    = "0.5"
    memory = "1.5"
    environment_variables = {
        "RUNNER_NAME"  = uc-cust-github-runner
        "RUNNER_TOKEN" = BBSWHMSMOVOGCCL6CEG62JDE5VO4O
        "ORG_NAME"     = Unknown-Cyber-Inc
        "REPO_URL"     = "https://github.com/Unknown-Cyber-Inc/AZ-UC-Cust-Infra"
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