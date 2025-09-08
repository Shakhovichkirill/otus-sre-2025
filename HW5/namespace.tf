# Создание namespace для Flask
resource "kubernetes_namespace_v1" "flask_app" {
  metadata {
    # Имя namespace
    name = "flask-production"

    # Дополнительные метки (опционально, но полезно для организации)
    labels = {
      "app"     = "flask-app"
      "env"     = "production"
      "team"    = "backend"
      "managed" = "terraform" 
   }

    annotations = {
      "description" = "Namespace for Flask application"
    }
  }
}

# Output value для удобства использования в других модулях
output "flask_namespace_name" {
  description = "The name of the created Kubernetes namespace for the Flask app"
  value       = kubernetes_namespace_v1.flask_app.metadata[0].name
}