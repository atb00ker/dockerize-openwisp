variable "external_ip" {
  type    = "list"
  default = ["192.168.1.6"]
}

# Number of pods to be lauched for openwisp-radius
variable "radius_instances" {
  type    = "string"
  default = 1
}

# Number of pods to be lauched for openwisp-controller
variable "controller_instances" {
  type    = "string"
  default = 1
}

# Number of pods to be lauched for openwisp-dashboard
variable "dashboard_instances" {
  type    = "string"
  default = 1
}

# Number of pods to be lauched for openwisp-network-topology
variable "topology_instances" {
  type    = "string"
  default = 1
}
# Number of pods to be lauched for openwisp-network-topology
variable "redis_instances" {
  type    = "string"
  default = 1
}
