variable "external_ip" {
  type    = "list(string)"
  default = ["192.168.1.6"]
}

# Number of pods to be lauched for openwisp-radius
variable "radius_instances" {
  type    = "number"
  default = 4
}

# Number of pods to be lauched for openwisp-controller
variable "controller_instances" {
  type    = "number"
  default = 3
}

# Number of pods to be lauched for openwisp-dashboard
variable "dashboard_instances" {
  type    = "number"
  default = 1
}

# Number of pods to be lauched for openwisp-network-topology
variable "topology_instances" {
  type    = "number"
  default = 1
}
