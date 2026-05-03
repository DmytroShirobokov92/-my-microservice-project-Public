# final/modules/monitoring/outputs.tf

output "grafana_url" {
  value       = "Run: kubectl get svc grafana -n monitoring -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'"
  description = "Grafana URL"
}

output "prometheus_url" {
  value       = "Run: kubectl get svc prometheus-server -n monitoring -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'"
  description = "Prometheus access via port-forward"
}
