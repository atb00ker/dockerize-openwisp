resource "kubernetes_config_map" "openwisp-postgresql" {
  metadata {
    name = "postgres-config"

    labels {
      App = "openwisp-postgresql"
    }
  }

  data {
    POSTGRES_DB       = "openwisp_db"
    POSTGRES_USER     = "admin"
    POSTGRES_PASSWORD = "admin"
  }
}

resource "kubernetes_config_map" "common-config" {
  metadata {
    name = "common-config"
  }

  data {
    DB_HOST                        = "openwisp-postgresql"
    DJANGO_SECRET_KEY              = "MY_COMPANY_SECRET_KEY"
  }
}
