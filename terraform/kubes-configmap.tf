resource "kubernetes_config_map" "postgres" {
  metadata {
    name = "postgres-config"

    labels {
      App = "postgres"
    }
  }

  data {
    POSTGRES_MULTIPLE_DATABASES = "openwisp_db,openwisp_radius_db"
    POSTGRES_USER               = "admin"
    POSTGRES_PASSWORD           = "admin"
  }
}

resource "kubernetes_config_map" "common" {
  metadata {
    name = "common-config"
  }

  data {
    DJANGO_SECRET_KEY = "MY_COMPANY_SECRET_KEY"
  }
}

resource "kubernetes_config_map" "controller" {
  metadata {
    name = "controller-config"
  }

  data {
    DJANGO_REDIS_HOST = "localhost"
  }
}
