resource "google_compute_instance" "default" {
  count        = var.no_of_instances
  name         = "${var.instance_name}-${count.index + 1}"
  machine_type = var.machine_type
  zone         = var.zone
  project      = var.project_id
  tags         = var.tags
  advanced_machine_features {
    enable_nested_virtualization = var.enable_nested_virtualization
    threads_per_core             = var.threads_per_core
  }
  # guest_accelerator {
  #   type  = var.gpu_type
  #   count = var.gpu_count
  # }
  scheduling {
    automatic_restart   = false
    on_host_maintenance = "TERMINATE"
  }
  boot_disk {
    source = google_compute_disk.boot_disk[count.index].id
    kms_key_self_link = var.kms_key_self_link == "" ? null : var.kms_key_self_link
  }
  // Allow the instance to be stopped by terraform when updating configuration
  allow_stopping_for_update = var.allow_stopping_for_update

  network_interface {
    subnetwork = var.subnetwork
  }
  dynamic "attached_disk" {
    for_each = var.additional_disk_needed ? [for idx in range(var.no_of_instances) : idx] : []

    content {
      source     = google_compute_disk.additional_disk[attached_disk.key].self_link
      device_name = "additional-disk-${attached_disk.key + 1}"
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
    ignore_changes  = [attached_disk, labels, tags,boot_disk]
    create_before_destroy  = true

  }
}
resource "google_compute_disk" "boot_disk" {
  count     = var.no_of_instances
  project   = var.project_id
  name      = "${var.instance_name}-${count.index + 1}" 
  size      = var.boot_disk_size
  type      = var.boot_disk_type
  image     = var.boot_disk_image
  zone      = var.zone
}
resource "google_compute_disk" "additional_disk" {
  project   = var.project_id
  count     = var.additional_disk_needed ? var.no_of_instances : 0
  name      = "${var.disk_name}-${count.index + 1}" 
  size      = var.disk_size
  type      = var.disk_type
  zone      = var.zone
}

resource "google_compute_resource_policy" "policy" {
  project      = var.project_id
  name   = "gce-policy"
  region = var.region

  snapshot_schedule_policy {
    schedule {
      daily_schedule {
        days_in_cycle = 1
        start_time    = "01:00"
      }
    }
    retention_policy {
      max_retention_days    = 7
      on_source_disk_delete = "KEEP_AUTO_SNAPSHOTS"
    }
    snapshot_properties {
      labels = {
        my_label = "value"
      }
      storage_locations = ["asia"]
      guest_flush       = true
      # chain_name        = "test-schedule-chain-name"
    }
  }
}