variable "az_into365exch_infra_github_runner_token" {
    description = "az-into365exch-infra Repo Self Hosted Runner Token"
}

variable "az_into365exch_cust_github_runner_token" {
    description = "az-into365exch-cust Repo Self Hosted Runner Token"
}

#variable "containers" {
#  type = map(object({
#    acg_name      = string
#    docker_image  = string
#    runner_name   = string
#    repo_url      = string
#  }))
#  default = {
#    "infra" = {
#      acg_name     = "acg-into365exch-infra-github-runners"
#      docker_image = "myoung34/github-runner"
#      runner_name  = "az-into365exch-infra-github-runner"
#      repo_url     = "https://github.com/Unknown-Cyber-Inc/az-into365exch-infra"
#    }
#    "cust" = {
#      acg_name     = "acg-into365exch-cust-github-runners"
#      docker_image = "myoung34/github-runner"
#      runner_name  = "az-into365exch-cust-github-runner"
#      repo_url     = "https://github.com/Unknown-Cyber-Inc/az-into365exch-cust"
#    }
#  }
#}

variable "az_acg_name" {
    description = "The Name Of The Azure Container Group"
    default = "acg-into365exch-infra-github-runners"
}

variable "aci_docker_image" {
    description = "The Name Of The Image To Use For The Containers"
    default = "myoung34/github-runner"
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