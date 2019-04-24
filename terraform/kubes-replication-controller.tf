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
            container_port = 8000
          }

          env_from {
            config_map_ref {
              name = "${kubernetes_config_map.common-config.metadata.0.name}"
            }
          }

          volume_mount {
            name       = "openwisp-dashboard-static"
            mount_path = "/opt/openwisp/static/dashboard/"
          }
        }

        volume {
          name = "openwisp-dashboard-static"

          persistent_volume_claim {
            claim_name = "static-pv-claim"
          }
        }
      }
    }
  }

  depends_on = ["kubernetes_replication_controller.openwisp-postgresql",
    "kubernetes_replication_controller.redis",
  ]
}

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
            container_port = 8001
          }

          volume_mount {
            name       = "openwisp-postgres-data"
            mount_path = "/opt/openwisp/media"
          }

          volume_mount {
            name       = "openwisp-controller-static"
            mount_path = "/opt/openwisp/static/controller/"
          }

          env_from {
            config_map_ref {
              name = "${kubernetes_config_map.common-config.metadata.0.name}"
            }
          }
        }

        volume {
          name = "openwisp-controller-data"

          persistent_volume_claim {
            claim_name = "controller-pv-claim"
          }
        }

        volume {
          name = "openwisp-controller-static"

          persistent_volume_claim {
            claim_name = "static-pv-claim"
          }
        }
      }
    }
  }

  depends_on = ["kubernetes_persistent_volume.controller-pv-volume", "kubernetes_persistent_volume_claim.controller-pv-claim",
    "kubernetes_replication_controller.openwisp-postgresql",
    "kubernetes_replication_controller.redis",
  ]
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
              name = "${kubernetes_config_map.common-config.metadata.0.name}"
            }
          }

          volume_mount {
            name       = "openwisp-radius-static"
            mount_path = "/opt/openwisp/static/radius/"
          }
        }

        volume {
          name = "openwisp-radius-static"

          persistent_volume_claim {
            claim_name = "static-pv-claim"
          }
        }
      }
    }
  }

  depends_on = ["kubernetes_replication_controller.openwisp-postgresql"]
}

resource "kubernetes_replication_controller" "openwisp-topology" {
  metadata {
    name = "openwisp-topology"

    labels {
      App = "openwisp-topology"
    }
  }

  spec {
    replicas = "${var.topology_instances}"

    selector {
      App = "openwisp-topology"
    }

    template {
      metadata {
        labels {
          App = "openwisp-topology"
        }
      }

      spec {
        container {
          image = "atb00ker/ready-to-run:openwisp-network-topology"
          name  = "openwisp-topology"

          port {
            container_port = 8003
          }

          env_from {
            config_map_ref {
              name = "${kubernetes_config_map.common-config.metadata.0.name}"
            }
          }

          volume_mount {
            name       = "openwisp-topology-static"
            mount_path = "/opt/openwisp/static/topology/"
          }
        }

        volume {
          name = "openwisp-topology-static"

          persistent_volume_claim {
            claim_name = "static-pv-claim"
          }
        }
      }
    }
  }

  depends_on = ["kubernetes_replication_controller.openwisp-postgresql"]
}

resource "kubernetes_replication_controller" "openwisp-nginx" {
  metadata {
    name = "openwisp-nginx"

    labels {
      App = "openwisp-nginx"
    }
  }

  spec {
    replicas = 1

    selector {
      App = "openwisp-nginx"
    }

    template {
      metadata {
        labels {
          App = "openwisp-nginx"
        }
      }

      spec {
        container {
          image = "atb00ker/ready-to-run:openwisp-nginx"
          name  = "openwisp-nginx"

          port {
            name           = "dashboard"
            container_port = 8080
          }

          port {
            name           = "controller"
            container_port = 8081
          }

          port {
            name           = "radius"
            container_port = 8082
          }

          port {
            name           = "topology"
            container_port = 8083
          }

          volume_mount {
            name       = "openwisp-nginx-static"
            mount_path = "/opt/openwisp/static/"
          }
        }

        volume {
          name = "openwisp-nginx-static"

          persistent_volume_claim {
            claim_name = "static-pv-claim"
          }
        }
      }
    }
  }

  depends_on = ["kubernetes_replication_controller.openwisp-dashboard", "kubernetes_replication_controller.openwisp-controller",
    "kubernetes_replication_controller.openwisp-radius",
    "kubernetes_replication_controller.openwisp-topology",
  ]
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

resource "kubernetes_replication_controller" "redis" {
  metadata {
    name = "redis"

    labels {
      App = "redis"
    }
  }

  spec {
    replicas = "${var.redis_instances}"

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
