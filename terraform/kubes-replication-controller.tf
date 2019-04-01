resource "kubernetes_replication_controller" "openwisp-controller" {
  metadata {
    name = "openwisp-controller"

    labels {
      App = "openwisp-controller"
    }
  }

  spec {
    replicas = 3

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

  depends_on = ["kubernetes_replication_controller.postgres"]
}

resource "kubernetes_replication_controller" "openwisp-radius" {
  metadata {
    name = "openwisp-radius"

    labels {
      App = "openwisp-radius"
    }
  }

  spec {
    replicas = 4

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

  depends_on = ["kubernetes_replication_controller.postgres"]
}

resource "kubernetes_replication_controller" "openwisp-network-topology" {
  metadata {
    name = "openwisp-network-topology"

    labels {
      App = "openwisp-network-topology"
    }
  }

  spec {
    replicas = 1

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

  depends_on = ["kubernetes_replication_controller.postgres"]
}

resource "kubernetes_replication_controller" "openwisp-dashboard" {
  metadata {
    name = "openwisp-dashboard"

    labels {
      App = "openwisp-dashboard"
    }
  }

  spec {
    replicas = 1

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

  depends_on = ["kubernetes_replication_controller.postgres"]
}

resource "kubernetes_replication_controller" "postgres" {
  metadata {
    name = "postgres"

    labels {
      App = "postgres"
    }
  }

  spec {
    replicas = 1

    selector {
      App = "postgres"
    }

    template {
      metadata {
        labels {
          App = "postgres"
        }
      }

      spec {
        container {
          image = "postgres:10-alpine"
          name  = "postgres"

          port {
            container_port = 5432
          }

          volume_mount {
            name       = "postgredb"
            mount_path = "/var/lib/postgresql/data"
          }

          env_from {
            config_map_ref {
              name = "${kubernetes_config_map.postgres.metadata.0.name}"
            }
          }
        }

        volume {
          name = "postgredb"

          persistent_volume_claim {
            claim_name = "postgres-pv-claim"
          }
        }
      }
    }
  }

  depends_on = ["kubernetes_persistent_volume.postgres-pv-volume", "kubernetes_persistent_volume_claim.postgres-pv-claim"]
}
