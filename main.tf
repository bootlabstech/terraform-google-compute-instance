resource "google_compute_instance" "default" {
  deletion_protection = true
  count                         = var.no_of_instances
  name                          = var.name_of_instances[count.index]
  machine_type                  = var.machine_type
  zone                          = var.zone
  project                       = var.project
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
    automatic_restart     = true
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
 
 metadata = {
  enable-oslogin = "TRUE"
  windows-startup-script-ps1 = var.is_os_linux ? null : templatefile("${path.module}/windows_startup_script.tpl", {})

  # Exclude startup_script key when using the Windows startup script
  startup-script = var.is_os_linux ? templatefile("${path.module}/linux_startup_script.tpl", {}) : null
}
  network_interface {
    subnetwork = var.subnetwork
  }

  dynamic "service_account" {
    for_each = var.create_service_account ? [{}] : []

    content {
      email  = google_service_account.default[0].email
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
  service_account {
    email = "${data.google_project.service_project.number}-compute@developer.gserviceaccount.com"
    scopes = [
       "https://www.googleapis.com/auth/devstorage.read_only",
        "https://www.googleapis.com/auth/logging.write",
        "https://www.googleapis.com/auth/monitoring.write",
        "https://www.googleapis.com/auth/service.management.readonly",
         "https://www.googleapis.com/auth/servicecontrol",
        "https://www.googleapis.com/auth/trace.append",
    ]

}

}
 
resource "google_service_account" "default" {
  count        = var.create_service_account ? 1 : 0
  account_id   = "service-account-id"
  project      = var.project
}

resource "google_compute_address" "static" {
  count        = var.address_type == "INTERNAL" ? (var.address == "" ? 0 : 1) : 1
  name         = "compute-address"
  project      = var.compute_address_project
  region       = var.compute_address_region
  address_type = var.address_type
  subnetwork   = var.subnetwork
  address      = var.address_type == "INTERNAL" ? (var.address == "" ? null : var.address) : null
}