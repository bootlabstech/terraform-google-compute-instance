// required variables

# variable "no_of_instances" {
#   type        = number
#   description = "The number of instances to be created."
# }
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
variable "min_cpu_platform" {
  type        = string
  description = "Intel Skylake or Intel Haswell"
}
variable "enable_secure_boot" {
  type        = bool
}
variable "enable_integrity_monitoring" {
  type        = bool
}
variable "enable_oslogin" {
  type        = string
  default     = "TRUE"
}
variable "enable_nested_virtualization" {
  type        = bool
  description = "enable_nested_virtualization"
  default     = false
}
variable "threads_per_core" {
  type        = number
  description = "the number of threads per physical core. To disable simultaneous multithreading (SMT) set this to 1"
  default     = 1
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
  default     = true
}
variable "kms_key_self_link" {
  type        = string
  description = "The self_link of the encryption key that is stored in Google Cloud KMS to encrypt this disk."
  default     = ""
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
  default      = ""
}
variable "polociy_name" {
  type =  string
  description = "the policy  name for snapshot scheduler"
}
# schedule-instance-start-stop
# variable "resource_policy" {
#   type        = string
#   description = " The name of sceduled policy should be created"
# }

# variable "description" {
#   type        = string
#   description = "The name of start and stop"
# }

# variable "time_zone" {
#   type        = string
#   description = "the time zone to be used in interpreting the schedule"
# }

# variable "vm-scheduled_start" {
#   type        = string
#   description = "The schedule for starting instances."
# }

# variable "vm-scheduled_stop" {
#   type        = string
#   description = "the schedule for stopping instances"
# }

# variable "scheduling_enabled" {
#   type        = bool
#   description = "The schedule vm is need to be true but the default is false"
#   default     = false
# }
# variable "additional_disk_name" {
#   type        = string
#   description = "The schedule vm is need to be true but the default is false"

# }
# variable "gpu_type" {
#   description = ""
#   type = string
  
# }
# variable "gpu_count" {
#   description = ""
#   type = number
  
# }