// required variables
variable "name" {
  type        = string
  description = "A unique name for the resource, required by GCE. Changing this forces a new resource to be created."
}

variable "machine_type" {
  type        = string
  description = "The machine type to create."
}

variable "compute_address_region" {
  type        = string
  description = "The region that the compute address should be created in. If it is not provided, the provider zone is used."
}

variable "compute_address_project" {
  type        = string
  description = "The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
}
// optional variables

variable "zone" {
  type        = string
  description = "The zone that the machine should be created in. If it is not provided, the provider zone is used."
}

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
  description = "The name or self_link of the subnetwork to attach this interface to. Either network or subnetwork must be provided. If network isn't provided it will be inferred from the subnetwork. The subnetwork must exist in the same region this instance will be created in. If the network resource is in legacy mode, do not specify this field. If the network is in auto subnet mode, specifying the subnetwork is optional. If the network is in custom subnet mode, specifying the subnetwork is required."
}

variable "boot_disk_image" {
  description = "The image from which to initialize this disk. This can be one of: the image's self_link, projects/{project}/global/images/{image}, projects/{project}/global/images/family/{family}, global/images/{image}, global/images/family/{family}, family/{family}, {project}/{family}, {project}/{image}, {family}, or {image}. If referred by family, the images names must include the family name. If they don't, use the google_compute_image data source. For instance, the image centos-6-v20180104 includes its family name centos-6. These images can be referred by family name here."
  type        = string
}

variable "boot_disk_size" {
  description = "The size of the image in gigabytes. If not specified, it will inherit the size of its base image."
  type        = string
}

variable "boot_disk_type" {
  description = "The GCE disk type. May be set to pd-standard, pd-balanced or pd-ssd."
  type        = string
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
