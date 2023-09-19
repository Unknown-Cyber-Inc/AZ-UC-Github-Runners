variable "AZ_UC_CORE_INFRA_RUNNER_TOKEN" {
    description = "AZ_UC_CORE_INFRA Repo Self Hosted Runner Token"
}

variable "AZ_UC_CUST_INFRA_RUNNER_TOKEN" {
    description = "AZ_UC_CUST_INFRA Repo Self Hosted Runner Token"
}

variable "containers" {
  type = map(object({
    acg_name      = string
    docker_image  = string
    runner_name   = string
    runner_token  = string
    repo_url      = string
  }))
  default = {
    "core" = {
      acg_name     = "acg-uc-core-github-runners"
      docker_image = "myoung34/github-runner"
      runner_name  = "az-uc-core-infra-github-runner"
      runner_token = var.AZ_UC_CORE_INFRA_RUNNER_TOKEN
      repo_url     = "https://github.com/Unknown-Cyber-Inc/AZ-UC-Core-Infra"
    }
    "cust" = {
      acg_name     = "acg-uc-cust-github-runners"
      docker_image = "myoung34/github-runner"
      runner_name  = "az-uc-cust-infra-github-runner"
      runner_token = var.AZ_UC_CUST_INFRA_RUNNER_TOKEN
      repo_url     = "https://github.com/Unknown-Cyber-Inc/AZ-UC-Cust-Infra"
    }
  }
}
