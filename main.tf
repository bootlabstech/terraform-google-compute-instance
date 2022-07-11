resource "google_compute_instance" "default" {
  name         = var.name
  machine_type = var.machine_type
  zone         = var.zone
  project      = var.project

  tags = var.tags

  resource_policies = var.scheduling_enabled ? [google_compute_resource_policy.schedule_vm[0].id] : []
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

  metadata_startup_script = var.enable_startup_script ? templatefile("./startup.sh", {}) : null

  metadata = {
    enable-oslogin = "TRUE"
  }
  network_interface {
    subnetwork = var.subnetwork

    dynamic "access_config" {
      for_each = var.address_type == "EXTERNAL" ? [{}] : (var.address == "" ? [] : [{}])

      content {
        nat_ip = var.address_type == "EXTERNAL" ? google_compute_address.static[0].address : (var.address == "" ? null : google_compute_address.static[0].address)
      }
    }
  }

  dynamic "service_account" {
    for_each = var.create_service_account ? [{}] : []

    content {
      email  = google_service_account.default[0].email
      scopes = var.service_account_scopes
    }
  }

  shielded_instance_config {
    enable_secure_boot          = var.enable_secure_boot
    enable_integrity_monitoring = var.enable_integrity_monitoring
  }

  timeouts {
    create = "10m"
  }
}

resource "google_service_account" "default" {
  count        = var.create_service_account ? 1 : 0
  account_id   = format("%s-ci", var.name)
  display_name = format("%s Compute Instance", var.name)
  project      = var.project
}

resource "google_compute_address" "static" {
  count        = var.address_type == "INTERNAL" ? (var.address == "" ? 0 : 1) : 1
  name         = format("%s-external-ip", var.name)
  project      = var.compute_address_project
  region       = var.compute_address_region
  address_type = var.address_type
  subnetwork   = var.subnetwork
  address      = var.address_type == "INTERNAL" ? (var.address == "" ? null : var.address) : null
}


resource "google_compute_resource_policy" "schedule_vm" {
  count       = var.scheduling_enabled ? 1 : 0
  name        = var.resource_policy
  project     = var.project
  region      = var.compute_address_region
  description = var.description
  instance_schedule_policy {
    vm_start_schedule {
      schedule = var.vm-scheduled_start
    }
    vm_stop_schedule {
      schedule = var.vm-scheduled_stop
    }
    time_zone = var.time_zone
  }
}


