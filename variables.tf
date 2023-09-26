variable "az_uc_core_infra_runner_token" {
    description = "AZ_UC_CORE_INFRA Repo Self Hosted Runner Token"
}

variable "az_uc_cust_infra_runner_token" {
    description = "AZ_UC_CUST_INFRA Repo Self Hosted Runner Token"
}

variable "containers" {
  type = map(object({
    acg_name      = string
    docker_image  = string
    runner_name   = string
    repo_url      = string
  }))
  default = {
    "infra" = {
      acg_name     = "acg-into365exch-infra-github-runners"
      docker_image = "myoung34/github-runner"
      runner_name  = "az-into365exch-infra-github-runner"
      repo_url     = "https://github.com/Unknown-Cyber-Inc/az-into365exch-infra"
    }
    "cust" = {
      acg_name     = "acg-into365exch-cust-github-runners"
      docker_image = "myoung34/github-runner"
      runner_name  = "az-into365exch-cust-github-runner"
      repo_url     = "https://github.com/Unknown-Cyber-Inc/az-into365exch-cust"
    }
  }
}
