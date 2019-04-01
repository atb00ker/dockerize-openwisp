resource "kubernetes_persistent_volume" "postgres-pv-volume" {
  metadata {
    name = "postgres-pv-volume"

    labels {
      App  = "postgres"
      type = "local"
    }
  }

  spec {
    storage_class_name = "manual"

    capacity {
      storage = "1Gi"
    }

    access_modes = ["ReadWriteMany"]

    persistent_volume_source {
      host_path {
        path = "/mnt/data"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "postgres-pv-claim" {
  metadata {
    name = "postgres-pv-claim"

    labels {
      App = "postgres"
    }
  }

  spec {
    storage_class_name = "manual"
    access_modes       = ["ReadWriteMany"]

    resources {
      requests {
        storage = "1Gi"
      }
    }
  }

  depends_on = ["kubernetes_persistent_volume.postgres-pv-volume"]
}
