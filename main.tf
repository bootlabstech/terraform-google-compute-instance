resource "google_compute_instance" "default" {
  name         = var.name
  machine_type = var.machine_type
  zone         = var.zone
  project      = var.project_id

  tags = var.tags

  boot_disk {
    initialize_params {
      size  = var.boot_disk_size
      type  = var.boot_disk_type
      image = var.boot_disk_image
    }
  }

  // Allow the instance to be stopped by terraform when updating configuration
  allow_stopping_for_update = var.allow_stopping_for_update

  metadata_startup_script = var.enable_startup_script ? data.template_file.startup_script[0].rendered : null

  network_interface {
    subnetwork = var.subnetwork

    access_config {
      //Ephemeral IP
    }
  }

  dynamic "service_account" {
    for_each = var.create_service_account ? [{}] : []

    content {
      email  = google_service_account.default[0].email
      scopes = var.service_account_scopes
    }
  }
}

data "template_file" "startup_script" {
  count    = var.enable_startup_script != null ? 1 : 0
  template = file("startup.sh")
}

resource "google_service_account" "default" {
  count        = var.create_service_account ? 1 : 0
  account_id   = format("%s-compute-instance", var.name)
  display_name = format("%s Compute Instance", var.name)
  project      = var.project
}