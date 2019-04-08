resource "kubernetes_replication_controller" "openwisp-controller" {
  metadata {
    name = "openwisp-controller"

    labels {
      App = "openwisp-controller"
    }
  }

  spec {
    replicas = "${var.controller_instances}"

    selector {
      App = "openwisp-controller"
    }

    template {
      metadata {
        labels {
          App = "openwisp-controller"
        }
      }

      spec {
        container {
          image = "atb00ker/ready-to-run:openwisp-controller"
          name  = "openwisp-controller"

          port {
            container_port = 8000
          }

          env_from {
            config_map_ref {
              name = "${kubernetes_config_map.common.metadata.0.name}"
            }
          }

          env_from {
            config_map_ref {
              name = "${kubernetes_config_map.controller.metadata.0.name}"
            }
          }
        }

        container {
          image = "redis:alpine"
          name  = "redis"
        }
      }
    }
  }

  depends_on = ["kubernetes_replication_controller.openwisp-postgresql"]
}

resource "kubernetes_replication_controller" "openwisp-radius" {
  metadata {
    name = "openwisp-radius"

    labels {
      App = "openwisp-radius"
    }
  }

  spec {
    replicas = "${var.radius_instances}"

    selector {
      App = "openwisp-radius"
    }

    template {
      metadata {
        labels {
          App = "openwisp-radius"
        }
      }

      spec {
        container {
          image = "atb00ker/ready-to-run:openwisp-radius"
          name  = "openwisp-radius"

          port {
            container_port = 8002
          }

          env_from {
            config_map_ref {
              name = "${kubernetes_config_map.common.metadata.0.name}"
            }
          }
        }
      }
    }
  }

  depends_on = ["kubernetes_replication_controller.openwisp-postgresql"]
}

resource "kubernetes_replication_controller" "openwisp-network-topology" {
  metadata {
    name = "openwisp-network-topology"

    labels {
      App = "openwisp-network-topology"
    }
  }

  spec {
    replicas = "${var.topology_instances}"

    selector {
      App = "openwisp-network-topology"
    }

    template {
      metadata {
        labels {
          App = "openwisp-network-topology"
        }
      }

      spec {
        container {
          image = "atb00ker/ready-to-run:openwisp-network-topology"
          name  = "openwisp-network-topology"

          port {
            container_port = 8001
          }

          env_from {
            config_map_ref {
              name = "${kubernetes_config_map.common.metadata.0.name}"
            }
          }
        }
      }
    }
  }

  depends_on = ["kubernetes_replication_controller.openwisp-postgresql"]
}

resource "kubernetes_replication_controller" "openwisp-dashboard" {
  metadata {
    name = "openwisp-dashboard"

    labels {
      App = "openwisp-dashboard"
    }
  }

  spec {
    replicas = "${var.dashboard_instances}"

    selector {
      App = "openwisp-dashboard"
    }

    template {
      metadata {
        labels {
          App = "openwisp-dashboard"
        }
      }

      spec {
        container {
          image = "atb00ker/ready-to-run:openwisp-dashboard"
          name  = "openwisp-dashboard"

          port {
            container_port = 8003
          }

          env_from {
            config_map_ref {
              name = "${kubernetes_config_map.common.metadata.0.name}"
            }
          }
        }
      }
    }
  }

  depends_on = ["kubernetes_replication_controller.openwisp-postgresql"]
}

resource "kubernetes_replication_controller" "redis" {
  metadata {
    name = "redis"

    labels {
      App = "redis"
    }
  }

  spec {
    replicas = 1

    selector {
      App = "redis"
    }

    template {
      metadata {
        labels {
          App = "redis"
        }
      }

      spec {
        container {
          image = "redis:alpine"
          name  = "redis"

          port {
            container_port = 6379
          }
        }
      }
    }
  }
}

resource "kubernetes_replication_controller" "openwisp-postgresql" {
  metadata {
    name = "openwisp-postgresql"

    labels {
      App = "openwisp-postgresql"
    }
  }

  spec {
    replicas = 1

    selector {
      App = "openwisp-postgresql"
    }

    template {
      metadata {
        labels {
          App = "openwisp-postgresql"
        }
      }

      spec {
        container {
          image = "atb00ker/ready-to-run:openwisp-postgresql"
          name  = "openwisp-postgresql"

          port {
            container_port = 5432
          }

          volume_mount {
            name       = "openwisp-postgres-data"
            mount_path = "/var/lib/postgresql/data"
          }

          env_from {
            config_map_ref {
              name = "${kubernetes_config_map.openwisp-postgresql.metadata.0.name}"
            }
          }
        }

        volume {
          name = "openwisp-postgres-data"

          persistent_volume_claim {
            claim_name = "postgres-pv-claim"
          }
        }
      }
    }
  }

  depends_on = ["kubernetes_persistent_volume.postgres-pv-volume", "kubernetes_persistent_volume_claim.postgres-pv-claim"]
}
