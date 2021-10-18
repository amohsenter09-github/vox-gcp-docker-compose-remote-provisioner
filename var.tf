

variable "region_name" {
  type        = string
  description = "The region that this terraform configuration will instanciate at."
  default     = "europe-west3"
}

variable "zone_name" {
  type        = string
  description = "The zone that this terraform configuration will instanciate at."
  default     = "europe-west3-a"
}

variable "machine_size" {
  type        = string
  description = "The size that this instance will be."
  default     = "f1-micro"
}

variable "image_name" {
  type        = string
  description = "The kind of VM this instance will become"
  default     = "debian-cloud/debian-9"
}

variable "script_path" {
  type        = string
  description = "Where is the path to the script locally on the machine?"
  default = ""
}

variable "private_key_path" {
  type        = string
  description = "The path to the private key used to connect to the instance"
  default = ""
}

variable "username" {
  type        = string
  description = "The name of thegit config --get remote.origin.url user that will be used to remote exec the script"
  default = "amohsen"
}
