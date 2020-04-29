
output "project_id" {
  value       = var.project_id
  description = "The project to run tests against"
}

output "name" {
  value       = local.instance_name
  description = "The name for Cloud SQL instance"
}

output "self_link" {
  description = "link for your sql database instance"
  value       = google_sql_database_instance.sqlserver.self_link
}

output "public_ip_address" {
  description = "Public ip address to connect to this Database"
  value       = google_sql_database_instance.sqlserver.public_ip_address
}

output "instance_id" {
  description = "Id of the Cloud SQL instance"
  value       = google_sql_database_instance.sqlserver.id
}

output "username" {
  description = "Username to connect to this Database"
  value       = "sqlserver"
}

output "password" {
  description = "Password to connect to this Database"
  value       = google_sql_database_instance.sqlserver.root_password
}

output "db_name" {
  value       = google_sql_database.test_db.name
  description = "The name of the Database to connect to"
}

