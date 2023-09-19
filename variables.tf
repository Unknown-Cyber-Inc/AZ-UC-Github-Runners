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
      runner_token = "BBSTPEKTEJ2BKFB2YR6I4ADFBG7OQ"
      repo_url     = "https://github.com/Unknown-Cyber-Inc/AZ-UC-Core-Infra"
    }
    "cust" = {
      acg_name     = "acg-uc-cust-github-runners"
      docker_image = "myoung34/github-runner"
      runner_name  = "az-uc-core-infra-github-runner"
      runner_token = "BBSTPEKCZWHZUIQSFLJTUZDFBHDL2"
      repo_url     = "https://github.com/Unknown-Cyber-Inc/AZ-UC-Core-Infra"
    }
  }
}
