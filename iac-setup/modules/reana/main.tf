resource "helm_release" "reana_chart" {
  name       = var.release_name
  repository = "https://reanahub.github.io/reana"
  chart      = "reana"
  version    = "0.9.0-alpha.6"
  namespace  = var.ns_name

  values = [
    file("${path.module}/values.yaml")
  ]
}