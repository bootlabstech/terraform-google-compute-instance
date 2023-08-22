resource "google_compute_address" "edge-server-anthos-static-internal-ip" {
  address_type = "INTERNAL"
  subnetwork   = var.subnetwork
  name     = "edge-server-anthos-internal-ip"
  project = var.project_id
  region  = var.region
}

resource "google_compute_address" "edge-server-anthos-static-external-ip" {
  address_type = "EXTERNAL"
  name     = "edge-server-anthos-external-ip"
  project = var.project_id
  region  = var.region
}
resource "google_compute_instance" "default" {
  count                         = var.no_of_instances
  name                          = var.name_of_instances[count.index]
  machine_type                  = var.machine_type
  zone                          = var.zone
  project                       = var.project_id
  tags                          = var.tags
  advanced_machine_features {
  enable_nested_virtualization  = var.enable_nested_virtualization
  threads_per_core              = var.threads_per_core
  }
  guest_accelerator  {
    type   = var.gpu_type
    count = var.gpu_count
  }
  scheduling {
    automatic_restart     = false
    on_host_maintenance   = "TERMINATE"
  }
 

  boot_disk {
    initialize_params {
      size  = var.boot_disk_size
      type  = var.boot_disk_type
      image = var.boot_disk_image
    }
    kms_key_self_link = var.kms_key_self_link == "" ? null : var.kms_key_self_link
  }

  // Allow the instance to be stopped by terraform when updating configuration
  allow_stopping_for_update = var.allow_stopping_for_update

  network_interface {
    network = var.network
    network_ip = google_compute_address.edge-server-anthos-static-internal-ip.address
    access_config {
      nat_ip =  google_compute_address.edge-server-anthos-static-external-ip.address
    }
  }

  dynamic "service_account" {
    for_each = var.create_service_account ? [{}] : []

    content {
      email  = var.service_account_email
      scopes = var.service_account_scopes
    }
  }

  shielded_instance_config {
    enable_secure_boot          = true
    enable_integrity_monitoring = true
  }

  timeouts {
    create = "10m"
  }

  lifecycle {
    ignore_changes = [attached_disk,labels,tags]
  }

}