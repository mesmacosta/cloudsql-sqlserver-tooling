provider "google" {
  version = "~> 3.8"
  project = var.project_id
  region  = var.project_region
}

provider "google-beta" {
  version = "~> 3.8"
}

provider "null" {
  version = "~> 2.1"
}

provider "random" {
  version = "~> 2.2"
}

resource "random_id" "name" {
  byte_length = 2
}

resource "random_id" "pass" {
  byte_length = 16
}