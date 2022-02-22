// required variables
variable "name" {
  type        = string
  description = "A unique name for the resource, required by GCE. Changing this forces a new resource to be created."
}

variable "machine_type" {
  type        = string
  description = <<-EOT
  {
   "type": "json",
   "purpose": "autocomplete",
   "data": [ "c2-standard-16",    
             "c2-standard-30",
             "c2-standard-4",
             "c2-standard-60",
             "c2-standard-8",
             "e2-highcpu-16",
             "e2-highcpu-2",
             "e2-highcpu-32",
             "e2-highcpu-4",
             "e2-highcpu-8",
             "e2-highmem-16",
             "e2-highmem-2",
             "e2-highmem-4",
             "e2-highmem-8",
             "e2-medium",
             "e2-micro",
             "e2-small",
             "e2-standard-16",
             "e2-standard-2",
             "e2-standard-32",
             "e2-standard-4",
             "e2-standard-8",
             "f1-micro",
             "g1-small",
             "m1-megamem-96",
             "m1-ultramem-160",
             "m1-ultramem-40",
             "m1-ultramem-80",
             "m2-megamem-416",
             "m2-ultramem-208",
             "m2-ultramem-416",
             "n1-highcpu-16",
             "n1-highcpu-2",
             "n1-highcpu-32",
             "n1-highcpu-4",
             "n1-highcpu-64",
             "n1-highcpu-8",
             "n1-highcpu-96",
             "n1-highmem-16",
             "n1-highmem-2",
             "n1-highmem-32",
             "n1-highmem-4",
             "n1-highmem-64",
             "n1-highmem-8",
             "n1-highmem-96",
             "n1-standard-1",
             "n1-standard-16",
             "n1-standard-2",
             "n1-standard-32",
             "n1-standard-4",
             "n1-standard-64",
             "n1-standard-8",
             "n1-standard-96",
             "n1-ultramem-160",
             "n1-ultramem-40",
             "n1-ultramem-80",
             "n2-highcpu-16",
             "n2-highcpu-2",
             "n2-highcpu-32",
             "n2-highcpu-4",
             "n2-highcpu-48",
             "n2-highcpu-64",
             "n2-highcpu-8",
             "n2-highcpu-80",
             "n2-highmem-16",
             "n2-highmem-2",
             "n2-highmem-32",
             "n2-highmem-4",
             "n2-highmem-48",
             "n2-highmem-64",
             "n2-highmem-8",
             "n2-highmem-80",
             "n2-standard-16",
             "n2-standard-2",
             "n2-standard-32",
             "n2-standard-4",
             "n2-standard-48",
             "n2-standard-64",
             "n2-standard-8",
             "n2-standard-80",
             "n2d-highcpu-128",
             "n2d-highcpu-16",
             "n2d-highcpu-2",
             "n2d-highcpu-224",
             "n2d-highcpu-32",
             "n2d-highcpu-4",
             "n2d-highcpu-48",
             "n2d-highcpu-64",
             "n2d-highcpu-8",
             "n2d-highcpu-80",
             "n2d-highcpu-96",
             "n2d-highmem-16",
             "n2d-highmem-2",
             "n2d-highmem-32",
             "n2d-highmem-4",
             "n2d-highmem-48",
             "n2d-highmem-64",
             "n2d-highmem-8",
             "n2d-highmem-80",
             "n2d-highmem-96",
             "n2d-standard-128",
             "n2d-standard-16",
             "n2d-standard-2",
             "n2d-standard-224",
             "n2d-standard-32",
             "n2d-standard-4",
             "n2d-standard-48",
             "n2d-standard-64",
             "n2d-standard-8",
             "n2d-standard-80",
             "n2d-standard-96"
            ],
   "description": "The machine type to create."
}
EOT
}

variable "compute_address_region" {
  type        = string
  description = <<-EOT
  {
   "type": "json",
   "purpose": "autocomplete",
   "data": "/api/v1/autocomplete/regions",
   "description": "The region that the compute address should be created in. If it is not provided, the provider region is used."
}
EOT
}

variable "compute_address_project" {
  type        = string
  description = "The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
}
// optional variables

variable "zone" {
  type        = string
  description = <<-EOT
  {
   "type": "json",
   "purpose": "autocomplete",
   "data": "/api/v1/autocomplete/zones",
   "description": "The zone that the machine should be created in. If it is not provided, the provider zone is used."
}
EOT
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
  description = <<-EOT
  {
   "type": "json",
   "purpose": "autocomplete",
   "data":["centos-7-v20220126",
            "centos-stream-8-v20220128",
            "cos-85-13310-1416-5",
            "cos-89-16108-604-11",
            "cos-93-16623-102-12",
            "cos-beta-93-16623-39-6",
            "debian-10-buster-v20220118",
            "debian-11-bullseye-v20220120",
            "debian-9-stretch-v20220118",
            "fedora-cloud-base-gcp-33-1-2-x86-64",
            "fedora-cloud-base-gcp-34-1-2-x86-64",
            "fedora-cloud-base-gcp-35-1-2-x86-64",
            "opensuse-leap-15-2-v20200702",
            "opensuse-leap-15-3-v20220128",
            "rhel-7-v20220126",
            "rhel-8-v20220126",
            "rhel-7-6-sap-v20220126",
            "rhel-7-7-sap-v20220126",
            "rhel-7-9-sap-v20220126",
            "rhel-8-1-sap-v20220126",
            "rhel-8-2-sap-v20220126",
            "rhel-8-4-sap-v20220126",
            "rocky-linux-8-v20220126",
            "sles-12-sp5-v20220126",
            "sles-15-sp3-v20220126",
            "sles-12-sp3-sap-v20220201",
            "sles-12-sp4-sap-v20220201",
            "sles-12-sp5-sap-v20220126",
            "sles-15-sap-v20220126",
            "sles-15-sp1-sap-v20220126",
            "sles-15-sp2-sap-v20220126",
            "sles-15-sp3-sap-v20220126",
            "ubuntu-1804-bionic-v20220213",
            "ubuntu-pro-1604-xenial-v20211213",
            "ubuntu-pro-1804-bionic-v20220131",
            "ubuntu-pro-2004-focal-v20220204",
            "windows-server-2012-r2-dc-core-v20220210",
            "windows-server-2012-r2-dc-v20220210",
            "windows-server-2016-dc-core-v20220210",
            "sql-2012-enterprise-windows-2012-r2-dc-v20220210",
            "sql-2012-standard-windows-2012-r2-dc-v20220210",
            "sql-2012-web-windows-2012-r2-dc-v20220210",
            "sql-2014-enterprise-windows-2012-r2-dc-v20220210",
            "sql-2014-enterprise-windows-2016-dc-v20220210",
            "sql-2014-standard-windows-2012-r2-dc-v20220210",
            "sql-2014-web-windows-2012-r2-dc-v20220210",
            "cos-dev-97-16882-0-0",
            "cos-stable-93-16623-102-12",
            "ubuntu-2004-focal-v20220204",
            "ubuntu-2110-impish-v20220204",
            "ubuntu-minimal-1804-bionic-v20220208",
            "ubuntu-minimal-2004-focal-v20220203",
            "ubuntu-minimal-2110-impish-v20220203",
            "windows-server-2016-dc-v20220210",
            "windows-server-2019-dc-core-for-containers-v20220211",
            "windows-server-2019-dc-core-v20220210",
            "windows-server-2019-dc-for-containers-v20220211",
            "windows-server-2019-dc-v20220210",
            "windows-server-2022-dc-core-v20220215",
            "windows-server-2022-dc-v20220215",
            "windows-server-20h2-dc-core-v20220210",
            "sql-2016-enterprise-windows-2012-r2-dc-v20220210",
            "sql-2016-enterprise-windows-2016-dc-v20220210",
            "sql-2016-enterprise-windows-2019-dc-v20220210",
            "sql-2016-standard-windows-2012-r2-dc-v20220210",
            "sql-2016-standard-windows-2016-dc-v20220210",
            "sql-2016-standard-windows-2019-dc-v20220210",
            "sql-2016-web-windows-2012-r2-dc-v20220210",
            "sql-2016-web-windows-2016-dc-v20220210",
            "sql-2016-web-windows-2019-dc-v20220210",
            "fedora-coreos-35-20220131-3-0-gcp-x86-64",
            "fedora-coreos-35-20220213-1-0-gcp-x86-64",
            "fedora-coreos-35-20220213-2-0-gcp-x86-64",
            "sql-2017-enterprise-windows-2016-dc-v20220210",
            "sql-2017-enterprise-windows-2019-dc-v20220210",
            "sql-2017-enterprise-windows-2022-dc-v20220216",
            "sql-2017-express-windows-2012-r2-dc-v20220210",
            "sql-2017-express-windows-2016-dc-v20220210",
            "sql-2017-express-windows-2019-dc-v20220210",
            "sql-2017-standard-windows-2016-dc-v20220210",
            "sql-2017-standard-windows-2019-dc-v20220210",
            "sql-2017-standard-windows-2022-dc-v20220216",
            "sql-2017-web-windows-2016-dc-v20220210",
            "sql-2017-web-windows-2019-dc-v20220210",
            "sql-2017-web-windows-2022-dc-v20220216",
            "sql-2019-enterprise-windows-2019-dc-v20220210",
            "sql-2019-enterprise-windows-2022-dc-v20220216",
            "sql-2019-standard-windows-2019-dc-v20220210",
            "sql-2019-standard-windows-2022-dc-v20220216",
            "sql-2019-web-windows-2019-dc-v20220211",
            "sql-2019-web-windows-2022-dc-v20220216"
            ],
    "description": "The boot_disk_image for the compute instance"
}
EOT
  type        = string
}

variable "boot_disk_size" {
  description = "The size of the image in gigabytes. If not specified, it will inherit the size of its base image."
  type        = string
}

variable "boot_disk_type" {
  description = <<-EOT
  {
   "type": "json",
   "purpose": "autocomplete",
   "data": ["pd-standard",
   "pd-balanced",
   "pd-ssd"   
   ],
   "description": "The GCE disk type,"
}
EOT
  type        = string
}

variable "enable_startup_script" {
  type        = bool
  description = <<-EOT
  {
   "type": "json",
   "purpose": "autocomplete",
   "data": ["true",
            "false"   
   ],
   "description": "Enable startup script, include startup.sh"
}
EOT
  default     = false
}

variable "create_service_account" {
  type        = bool
  description = <<-EOT
  {
   "type": "json",
   "purpose": "autocomplete",
   "data": ["true",
            "false"   
   ],
   "description": "Create service account for the compute instance"
}
EOT
  default     = false
}

variable "service_account_scopes" {
  type        = list(string)
  description = "A list of service scopes. Both OAuth2 URLs and gcloud short names are supported. To allow full access to all Cloud APIs, use the cloud-platform scope."
  default     = ["cloud-platform"]
}

variable "allow_stopping_for_update" {
  type        = bool
  description = <<-EOT
  {
   "type": "json",
   "purpose": "autocomplete",
   "data": ["true",
            "false"   
   ],
   "description": "If true, allows Terraform to stop the instance to update its properties"
}
EOT
  default     = false
}
