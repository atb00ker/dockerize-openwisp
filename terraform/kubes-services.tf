resource "kubernetes_service" "openwisp-controller" {
  metadata {
    name = "openwisp-controller"
  }

  spec {
    selector {
      App = "${kubernetes_replication_controller.openwisp-controller.metadata.0.labels.App}"
    }

    port {
      port        = 8000
      target_port = 8000
    }

    external_ips = "${var.external_ip}"
    type         = "LoadBalancer"
  }
}

resource "kubernetes_service" "openwisp-network-topology" {
  metadata {
    name = "openwisp-network-topology"
  }

  spec {
    selector {
      App = "${kubernetes_replication_controller.openwisp-network-topology.metadata.0.labels.App}"
    }

    port {
      port        = 8001
      target_port = 8001
    }

    external_ips = "${var.external_ip}"
    type         = "LoadBalancer"
  }
}

resource "kubernetes_service" "openwisp-radius" {
  metadata {
    name = "openwisp-radius"
  }

  spec {
    selector {
      App = "${kubernetes_replication_controller.openwisp-radius.metadata.0.labels.App}"
    }

    port {
      port        = 8002
      target_port = 8002
    }

    external_ips = "${var.external_ip}"
    type         = "LoadBalancer"
  }
}

resource "kubernetes_service" "openwisp-dashboard" {
  metadata {
    name = "openwisp-dashboard"
  }

  spec {
    selector {
      App = "${kubernetes_replication_controller.openwisp-dashboard.metadata.0.labels.App}"
    }

    port {
      port        = 8003
      target_port = 8003
    }

    external_ips = "${var.external_ip}"
    type         = "LoadBalancer"
  }
}

resource "kubernetes_service" "openwisp-postgresql" {
  metadata {
    name = "openwisp-postgresql"

    labels {
      App = "openwisp-postgresql"
    }
  }

  spec {
    selector {
      App = "${kubernetes_replication_controller.openwisp-postgresql.metadata.0.labels.App}"
    }

    port {
      port        = 5432
      target_port = 5432
    }

    type = "NodePort"
  }
}

resource "kubernetes_service" "redis" {
  metadata {
    name = "redis"

    labels {
      App = "redis"
    }
  }

  spec {
    selector {
      App = "${kubernetes_replication_controller.redis.metadata.0.labels.App}"
    }

    port {
      port        = 6379
      target_port = 6379
    }

    type = "NodePort"
  }
}
