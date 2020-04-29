locals {
  instance_name = "${var.db_name}-${random_id.name.hex}"
  generated_password = "${var.user_password_prefix}_${random_id.pass.hex}"
}

resource "google_sql_database_instance" "sqlserver" {
  provider = google-beta
  name             = local.instance_name
  database_version = var.database_version
  region           = var.db_region
  root_password = local.generated_password
  project = var.project_id

  settings {
    ip_configuration {
      ipv4_enabled    = true
      private_network = null
      require_ssl     = false

      authorized_networks {
        name  = "test-machine-ip"
        value = var.test_machine_ip
      }
    }

    tier              = var.tier
    disk_size         = var.disk_size
    replication_type  = var.replication_type
    activation_policy = var.activation_policy
  }
}

resource "google_sql_database" "test_db" {
  provider = google-beta
  name     = var.db_name
  instance = google_sql_database_instance.sqlserver.name
  project = var.project_id
}

