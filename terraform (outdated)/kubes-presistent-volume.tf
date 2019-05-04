resource "kubernetes_persistent_volume" "postgres-pv-volume" {
  metadata {
    name = "postgres-pv-volume"

    labels {
      App  = "openwisp-postgresql"
      type = "local"
    }
  }

  spec {
    storage_class_name = "manual"

    capacity {
      storage = "100Mi"
    }

    access_modes = ["ReadWriteMany"]

    persistent_volume_source {
      host_path {
        path = "/opt/openwisp/psql"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "postgres-pv-claim" {
  metadata {
    name = "postgres-pv-claim"

    labels {
      App = "openwisp-postgresql"
    }
  }

  spec {
    storage_class_name = "manual"
    access_modes       = ["ReadWriteMany"]

    resources {
      requests {
        storage = "100Mi"
      }
    }
  }

  depends_on = ["kubernetes_persistent_volume.postgres-pv-volume"]
}

resource "kubernetes_persistent_volume" "controller-pv-volume" {
  metadata {
    name = "controller-pv-volume"

    labels {
      App  = "openwisp-controller"
      type = "local"
    }
  }

  spec {
    storage_class_name = "manual"

    capacity {
      storage = "100Mi"
    }

    access_modes = ["ReadWriteMany"]

    persistent_volume_source {
      host_path {
        path = "/opt/openwisp/media"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "controller-pv-claim" {
  metadata {
    name = "controller-pv-claim"

    labels {
      App = "openwisp-controller"
    }
  }

  spec {
    storage_class_name = "manual"
    access_modes       = ["ReadWriteMany"]

    resources {
      requests {
        storage = "100Mi"
      }
    }
  }

  depends_on = ["kubernetes_persistent_volume.controller-pv-volume"]
}

resource "kubernetes_persistent_volume" "static-pv-volume" {
  metadata {
    name = "static-pv-volume"
  }

  spec {
    storage_class_name = "manual"

    capacity {
      storage = "100Mi"
    }

    access_modes = ["ReadWriteMany"]

    persistent_volume_source {
      host_path {
        path = "/opt/openwisp/static"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "static-pv-claim" {
  metadata {
    name = "static-pv-claim"
  }

  spec {
    storage_class_name = "manual"
    access_modes       = ["ReadWriteMany"]

    resources {
      requests {
        storage = "100Mi"
      }
    }
  }

  depends_on = ["kubernetes_persistent_volume.static-pv-volume"]
}
