// required variables
variable "compute_address_region" {
  type        = string
  description = "The region that the compute address should be created in. If it is not provided, the provider zone is used."
}
variable "compute_address_project" {
  type        = string
  description = "The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
}
variable "name" {
  type        = string
  description = "The name of the compute_instance"
}
// optional variables

variable "project" {
  type        = string
  description = "The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
}

variable "tags" {
  type        = list(string)
  description = "A list of network tags to attach to the instance."
  default     = []
}

variable "network" {
  type        = string
  description = " The name or self_link of the network to attach this interface to. Either network or subnetwork must be provided. If network isn't provided it will be inferred from the subnetwork."
}

variable "subnetwork" {
  type        = string
  description = "The name or self_link of the subnetwork to attach this interface to. Either network or subnetwork must be provided."
}
variable "enable_startup_script" {
  type        = bool
  description = "Enable startup script, include startup.sh"
  default     = false
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
  default     = false
}
variable "kms_key_self_link" {
  type        = string
  description = "The self_link of the encryption key that is stored in Google Cloud KMS to encrypt this disk."
  default     = ""
}
variable "address_type" {
  type        = string
  description = "The type of address to reserve. Default value is EXTERNAL. Possible values are INTERNAL and EXTERNAL"
}
variable "address" {
  type        = string
  description = "The private ip of the compute-instance"
  default      = ""
}
# schedule-instance-start-stop
variable "resource_policy" {
  type        = string
  description = " The name of sceduled policy should be created"
}

variable "description" {
  type        = string
  description = "The name of start and stop"
}

variable "time_zone" {
  type        = string
  description = "the time zone to be used in interpreting the schedule"
}

variable "vm-scheduled_start" {
  type        = string
  description = "The schedule for starting instances."
}

variable "vm-scheduled_stop" {
  type        = string
  description = "the schedule for stopping instances"
}

variable "scheduling_enabled" {
  type        = bool
  description = "The schedule vm is need to be true but the default is false"
  default     = false
}
variable "instances" {
  type = list(object({
    name            = string,
    machine_type    = string,
    zone            = string,
    boot_disk_size  = string,
    boot_disk_type  = string,
    boot_disk_image = string,
  }))
}