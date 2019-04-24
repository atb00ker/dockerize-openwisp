resource "kubernetes_service" "openwisp-dashboard" {
  metadata {
    name = "dashboard"
  }

  spec {
    selector {
      App = "${kubernetes_replication_controller.openwisp-dashboard.metadata.0.labels.App}"
    }

    port {
      port        = 8000
      target_port = 8000
    }

    type = "LoadBalancer"
  }
}

resource "kubernetes_service" "openwisp-controller" {
  metadata {
    name = "controller"
  }

  spec {
    selector {
      App = "${kubernetes_replication_controller.openwisp-controller.metadata.0.labels.App}"
    }

    port {
      port        = 8001
      target_port = 8001
    }

    type = "LoadBalancer"
  }
}

resource "kubernetes_service" "openwisp-radius" {
  metadata {
    name = "radius"
  }

  spec {
    selector {
      App = "${kubernetes_replication_controller.openwisp-radius.metadata.0.labels.App}"
    }

    port {
      port        = 8002
      target_port = 8002
    }

    type = "LoadBalancer"
  }
}

resource "kubernetes_service" "openwisp-topology" {
  metadata {
    name = "topology"
  }

  spec {
    selector {
      App = "${kubernetes_replication_controller.openwisp-topology.metadata.0.labels.App}"
    }

    port {
      port        = 8003
      target_port = 8003
    }

    type = "LoadBalancer"
  }
}

resource "kubernetes_service" "openwisp-nginx" {
  metadata {
    name = "openwisp-nginx"

    labels {
      App = "openwisp-nginx"
    }
  }

  spec {
    selector {
      App = "${kubernetes_replication_controller.openwisp-nginx.metadata.0.labels.App}"
    }

    port {
      name = "dashboard"
      port = 8080
    }

    port {
      name = "controller"
      port = 8081
    }

    port {
      name = "radius"
      port = 8082
    }

    port {
      name = "topology"
      port = 8083
    }

    external_ips = "${var.external_ip}"
    type         = "NodePort"
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
