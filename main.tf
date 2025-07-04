

resource "google_compute_instance" "default" {
  count        = var.no_of_instances
  name         = var.no_of_instances > 1 ? "${var.name_of_instance}-${count.index}" : var.name_of_instance
  machine_type = var.machine_type
  zone         = var.zone
  project      = var.project_id
  tags         = var.tags
  advanced_machine_features {
    enable_nested_virtualization = var.enable_nested_virtualization
    threads_per_core             = var.threads_per_core
  }
  boot_disk {
    source            = google_compute_disk.boot_disk[count.index].id
    kms_key_self_link = var.kms_key_self_link == "" ? null : var.kms_key_self_link
  }

  // Allow the instance to be stopped by terraform when updating configuration
  allow_stopping_for_update = var.allow_stopping_for_update

  metadata = {
    enable-oslogin             = var.enable_oslogin
    windows-startup-script-ps1 = var.is_os_linux ? null : templatefile("${path.module}/windows_startup_script.tpl", {})

    # Exclude startup_script key when using the Windows startup script
    startup-script = var.is_os_linux ? templatefile("${path.module}/linux_startup_script.tpl", {}) : null
  }

  network_interface {
    subnetwork = var.subnetwork
    network_ip = var.address == "" ? null : var.address
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

  lifecycle {
    ignore_changes = [boot_disk, attached_disk, labels, metadata, service_account, tags]
  }
  service_account {
    email = "${data.google_project.service_project.number}-compute@developer.gserviceaccount.com"
    scopes = [
       "https://www.googleapis.com/auth/cloud-platform",
    ]
    
  }

}

resource "google_compute_address" "static" {
  count        = var.address_type == "INTERNAL" ? (var.address == "" ? 0 : 1) : 1
  name         = var.no_of_instances > 1 ? "${var.name_of_instance}-${count.index}-staticip" : "${var.name_of_instance}--staticip"
  project      = var.project_id
  region       = var.compute_address_region
  address_type = var.address_type
  subnetwork   = var.subnetwork
  address      = var.address_type == "INTERNAL" ? (var.address == "" ? null : var.address) : null
}
resource "google_compute_disk" "boot_disk" {
  count   = var.no_of_instances
  project = var.project_id
  name    = var.no_of_instances > 1 ? "${var.name_of_instance}-${count.index}-maindisk" : "${var.name_of_instance}-maindisk"
  size    = var.boot_disk_size
  type    = var.boot_disk_type
  image   = var.boot_disk_image
  zone    = var.zone
    disk_encryption_key {
    kms_key_self_link = var.kms_key_self_link
  }
  depends_on = [ google_project_iam_binding.network_binding2 ]
}
resource "google_compute_disk" "additional_disk" {
  project = var.project_id
  count   = var.additional_disk_needed ? var.no_of_instances : 0
  name    = var.no_of_instances > 1 ? "${var.name_of_instance}-${count.index}-addtnl" : "${var.name_of_instance}-addtnl"
  size    = var.disk_size
  type    = var.disk_type
  zone    = var.zone
      disk_encryption_key {
    kms_key_self_link = var.kms_key_self_link
  }
}
resource "google_compute_attached_disk" "attachvmtoaddtnl" {
  count   = var.additional_disk_needed ? var.no_of_instances : 0
  disk     = google_compute_disk.additional_disk[count.index].id
  instance = var.no_of_instances > 1 ? "${var.name_of_instance}-${count.index}" : var.name_of_instance
  project  = var.project_id
  zone     = var.zone
  depends_on = [
    google_compute_disk.additional_disk,google_compute_instance.default
  ]
}     
resource "google_compute_resource_policy" "daily" {
  project = var.project_id
  name    = var.policy_name
  region  = "asia-south1"
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
      storage_locations = ["asia"]
      guest_flush       = true
    }
  }
}
data "google_project" "service_project" {
  project_id = var.project_id
}
resource "google_project_iam_binding" "network_binding2" {
  count   = 1
  project =var.project_id
  lifecycle {
    ignore_changes = [ members ]
  }
  role    = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  members = [
    "serviceAccount:service-${data.google_project.service_project.number}@compute-system.iam.gserviceaccount.com",
    
  ]
}