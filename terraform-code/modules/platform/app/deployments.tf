resource "kubernetes_deployment_v1" "demoapp_deployment" {
  metadata {
    name = "demoapp-deployment"
    labels = {
      app = "demoapp"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "demoapp"
      }
    }

    template {
      metadata {
        labels = {
          app = "demoapp"
        }
      }

      spec {
        container {
          name  = "nginx-container"
          image = "nginx:latest"

          port {
            container_port = 80
          }
        }
      }
    }
  }
}