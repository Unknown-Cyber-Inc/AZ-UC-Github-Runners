variable "az_acg_name" {
    description = "The Name Of The Azure Container Group"
    default = "acg-into365exch-infra-github-runners"
}

variable "az_resource_group" {
  description = "Resource Group For Containers"
}

variable "az_subnet_name" {
  description = "The Name Of The Subnet The Containers Will Be Created On"
}

variable "az_virtual_network_name" {
  description = "The Name Of The VNET That Contains The Containers Subnet"
}

variable "aci_docker_image" {
    description = "The Name Of The Image To Use For The Containers"
    default = "myoung34/github-runner"
}

variable "az_container_app_environment" {
  description = "The Name Of The Azure Container App Environment"
}

variable "gh_runner_group_name" {
    description = "The Name Of The Runner Group To Join The Runner To In Github"
    default = "into365exch-runners"
}

variable "gh_runner_scope" {
    description = "The Scope Of The Runner"
    default = "org"
}

variable "gh_runner_org_name" {
    description = "The Name Of The Organization In Github For The Runner"
    default = "Unknown-Cyber-Inc"
}

variable "access_token" {
  description = "The Github PAT Token Used To Register The Runners"
}

variable "ghrsubnetrg"{
  description = "The Name Of The Resource Group That Contains The Subnet The Github Runner Will Be Running On"
}

variable "env_vars" {
  type = "map"
  description = "Container Env Vars"

  default = {
    ACCESS_TOKEN         = var.access_token
    RUNNER_GROUP       =  var.access_token
    LABELS     =  each.key
    RUNNER_SCOPE      = var.gh_runner_scope
    ORG_NAME    = var.gh_runner_org_name
    DISABLE_AUTO_UPDATE = "true"
  }
}

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