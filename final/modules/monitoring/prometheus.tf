# final/modules/monitoring/prometheus.tf

resource "helm_release" "prometheus" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "prometheus"
  namespace        = "monitoring"
  create_namespace = true
  version          = "25.0.0"


    set =[
        {
            name = "server.service.type"
            value = "LoadBalancer"
        },

        {
            name = "server.service.port"
            value = "9090"
        }
    ]

}
