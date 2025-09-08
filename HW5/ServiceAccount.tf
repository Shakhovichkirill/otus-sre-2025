resource "kubernetes_service_account_v1" "flask_app" {
  metadata {
    name      = "flask-app-sa"
    namespace = kubernetes_namespace_v1.flask_app.metadata[0].name
  }
  automount_service_account_token = false 
}