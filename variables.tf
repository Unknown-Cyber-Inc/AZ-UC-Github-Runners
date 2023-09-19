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
    "core" = {
      acg_name     = "acg-uc-core-github-runners"
      docker_image = "myoung34/github-runner"
      runner_name  = "az-uc-core-infra-github-runner"
      repo_url     = "https://github.com/Unknown-Cyber-Inc/AZ-UC-Core-Infra"
    }
    "cust" = {
      acg_name     = "acg-uc-cust-github-runners"
      docker_image = "myoung34/github-runner"
      runner_name  = "az-uc-cust-infra-github-runner"
      repo_url     = "https://github.com/Unknown-Cyber-Inc/AZ-UC-Cust-Infra"
    }
  }
}
