data "google_project" "current" {
  project_id = var.project_id
}

data "google_kms_key_ring" "project_keyring" {
  project  = var.project_id
  name     = var.project_id
  location = var.compute_address_region
}

data "google_kms_crypto_key" "project_key" {
  name     = "${data.google_project.current.name}-key"
  key_ring = data.google_kms_key_ring.project_keyring.id
}

resource "google_project_service" "compute" {
  project            = var.project_id
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

data "google_compute_default_service_account" "compute_sa" {
  project    = var.project_id
  depends_on = [google_project_service.compute]
}

resource "time_sleep" "wait_for_compute_sa" {
  create_duration = "60s"

  depends_on = [
    data.google_compute_default_service_account.compute_sa
  ]
}

resource "google_kms_crypto_key_iam_member" "compute_cmek" {
  crypto_key_id = data.google_kms_crypto_key.project_key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:service-${data.google_project.current.number}@compute-system.iam.gserviceaccount.com"

  depends_on = [
    time_sleep.wait_for_compute_sa
  ]

  lifecycle {
    ignore_changes = [member]
  }
}

resource "google_compute_instance" "default" {
  count        = var.no_of_instances
  name         = var.no_of_instances > 1 ? "${var.name_of_instance}-${count.index}" : var.name_of_instance
  machine_type = var.machine_type
  zone         = var.zone
  project      = var.project_id
  tags         = var.tags
  labels       = var.labels

  advanced_machine_features {
    enable_nested_virtualization = var.enable_nested_virtualization
    threads_per_core             = var.threads_per_core
  }

  boot_disk {
    source            = google_compute_disk.boot_disk[count.index].id
    kms_key_self_link = data.google_kms_crypto_key.project_key.id
  }
  depends_on = [
    google_kms_crypto_key_iam_member.compute_cmek
  ]

  allow_stopping_for_update = var.allow_stopping_for_update

  metadata = {
    enable-oslogin             = var.enable_oslogin
    windows-startup-script-ps1 = var.is_os_linux ? null : templatefile("${path.module}/windows_startup_script.tpl", {})
    startup-script             = var.is_os_linux ? templatefile("${path.module}/linux_startup_script.tpl", {}) : null
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
    ignore_changes = [boot_disk, attached_disk, metadata, service_account]
  }

  service_account {
    email = "${data.google_project.current.number}-compute@developer.gserviceaccount.com"
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
    kms_key_self_link = data.google_kms_crypto_key.project_key.id
  }

  depends_on = [
    google_kms_crypto_key_iam_member.compute_cmek
  ]
}

resource "google_compute_disk" "additional_disk" {
  project = var.project_id
  count   = var.additional_disk_needed ? var.no_of_instances : 0
  name    = var.no_of_instances > 1 ? "${var.name_of_instance}-${count.index}-addtnl" : "${var.name_of_instance}-addtnl"
  size    = var.disk_size
  type    = var.disk_type
  zone    = var.zone

  disk_encryption_key {
    kms_key_self_link = data.google_kms_crypto_key.project_key.id
  }

  lifecycle {
    ignore_changes = [
      provisioned_iops
    ]
  }

  depends_on = [
    google_kms_crypto_key_iam_member.compute_cmek
  ]
}

resource "google_compute_attached_disk" "attachvmtoaddtnl" {
  count    = var.additional_disk_needed ? var.no_of_instances : 0
  disk     = google_compute_disk.additional_disk[count.index].id
  instance = var.no_of_instances > 1 ? "${var.name_of_instance}-${count.index}" : var.name_of_instance
  project  = var.project_id
  zone     = var.zone

  depends_on = [
    google_compute_disk.additional_disk,
    google_compute_instance.default
  ]
}

# data "google_project" "service_project" {
#   project_id = var.project_id
# }