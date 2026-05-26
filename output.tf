output "project_id" {
  description = "GCP Project ID"
  value       = var.project_id
}

output "cloud" {
  description = "Cloud Provider"
  value       = "GCP"
}

output "instance_self_link" {
  description = "GCP Instance Self Link"
  value       = google_compute_instance.default[0].self_link
}