terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "mongodb_index_corruption_causing_query_performance_issues" {
  source    = "./modules/mongodb_index_corruption_causing_query_performance_issues"

  providers = {
    shoreline = shoreline
  }
}