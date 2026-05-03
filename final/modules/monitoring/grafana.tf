# final/modules/monitoring/grafana.tf

resource "helm_release" "grafana" {
  name             = "grafana"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  namespace        = "monitoring"
  create_namespace = true
  version          = "8.0.0"

  values = [yamlencode({
    service = {
      type = "LoadBalancer"
      port = 3000
    }

    datasources = {
      "datasources.yaml" = {
        apiVersion = 1
        datasources = [
          {
            name      = "Prometheus"
            type      = "prometheus"
            access    = "proxy"
            url       = "http://prometheus-server.monitoring.svc.cluster.local"
            isDefault = true
          }
        ]
      }
    }
  })]

  set_sensitive = [
    {
      name  = "adminPassword"
      value = var.grafana_admin_password
    }
  ]
}