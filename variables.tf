// required variables

variable "no_of_instances" {
  type        = number
  description = "The number of instances to be created."
}
variable "name_of_instance" {
  type        = string
  description = "The name of instances to be created."
}
variable "machine_type" {
  type        = string
  description = "The type of machine to be created."
}
variable "zone" {
  type        = string
  description = "The zone of the VM."
}
variable "boot_disk_size" {
  type        = number
  description = "The boot_disk_size of the VM."
}

variable "boot_disk_type" {
  type        = string
  description = "The boot_disk_type of the VM."
}

variable "boot_disk_image" {
  type        = string
  description = "The boot_disk_image of the VM."
}

variable "compute_address_region" {
  type        = string
  description = "The region that the compute address should be created in. If it is not provided, the provider zone is used."
}
variable "compute_address_project" {
  type        = string
  description = "The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
}
variable "is_os_linux" {
  type        = bool
  description = "Executes different metadata scripts on this basis."
}

variable "enable_secure_boot" {
  type    = bool
  default = true
}
variable "enable_integrity_monitoring" {
  type    = bool
  default = true
}
variable "enable_oslogin" {
  type    = string
  default = "TRUE"
}
variable "enable_nested_virtualization" {
  type        = bool
  description = "enable_nested_virtualization"
}
variable "threads_per_core" {
  type        = number
  description = "the number of threads per physical core. To disable simultaneous multithreading (SMT) set this to 1"
}

// optional variables

variable "project_id" {
  type        = string
  description = "The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
}

variable "tags" {
  type        = list(string)
  description = "A list of network tags to attach to the instance."
}
variable "subnetwork" {
  type        = string
  description = "The name or self_link of the subnetwork to attach this interface to. Either network or subnetwork must be provided."
}
variable "enable_startup_script" {
  type        = bool
  description = "Enable startup script, include startup.sh"
}
variable "create_service_account" {
  type        = bool
  description = "Create service account for the compute instance"
  default     = false
}
variable "service_account_scopes" {
  type        = list(string)
  description = "A list of service scopes. Both OAuth2 URLs and gcloud short names are supported. To allow full access to all Cloud APIs, use the cloud-platform scope."
  default     = ["cloud-platform"]
}
variable "allow_stopping_for_update" {
  type        = bool
  description = "If true, allows Terraform to stop the instance to update its properties. If you try to update a property that requires stopping the instance without setting this field, the update will fail."
  default     = true
}
variable "kms_key_self_link" {
  type        = string
  description = "The self_link of the encryption key that is stored in Google Cloud KMS to encrypt this disk."
}
variable "additional_disk_needed" {
  type        = bool
  description = "Is Additional disk needed."
}

variable "address_type" {
  type        = string
  description = "The type of address to reserve. Default value is EXTERNAL. Possible values are INTERNAL and EXTERNAL"
}
variable "address" {
  type        = string
  description = "The private ip of the compute-instance"
  default     = ""
}
variable "policy_name" {
  type        = string
  description = "the policy  name for snapshot scheduler"
}
variable "disk_type" {
  type        = string
  description = "The additional_disk_type of the VM."
}
variable "disk_size" {
  type        = number
  description = "The addtnl_disk_size of the VM."
}