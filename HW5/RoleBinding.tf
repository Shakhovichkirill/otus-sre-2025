resource "kubernetes_role_v1" "flask_app" {
  metadata {
    name      = "flask-app-role"
    namespace = kubernetes_namespace_v1.flask_app.metadata[0].name
  }

  rule {
    api_groups = [""] 
    resources  = ["configmaps", "pods", "services", "secrets"]
    verbs      = ["get", "list", "watch"] # права только на чтение
  }
  
}

# RoleBinding
resource "kubernetes_role_binding_v1" "flask_app" {
  metadata {
    name      = "flask-app-rolebinding"
    namespace = kubernetes_namespace_v1.flask_app.metadata[0].name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role_v1.flask_app.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.flask_app.metadata[0].name
    namespace = kubernetes_namespace_v1.flask_app.metadata[0].name
  }
}