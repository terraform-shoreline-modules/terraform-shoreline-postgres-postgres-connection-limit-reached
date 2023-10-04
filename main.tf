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

module "postgres_connection_limit_reached" {
  source    = "./modules/postgres_connection_limit_reached"

  providers = {
    shoreline = shoreline
  }
}