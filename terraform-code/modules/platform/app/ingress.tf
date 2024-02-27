#resource "kubernetes_ingress_v1" "myapp_ingress" {
#  wait_for_load_balancer = true
#  metadata {
#    name = "example.com"
#    annotations = {
#      "kubernetes.io/ingress.class" = "nginx"
#    }
#  }
#  spec {
#    rule {
#      host = "*.example.com"
#      http {
#        path {
#          #path_type = "Prefix"
#          path = "/*"
#          backend {
#            service_name = "demoapp-lb-service"
#            service_port = 80
#          }
#        }
#      }
#    }
#  }
#}



resource "kubernetes_ingress_v1" "myapp-ingress" {
  metadata {
    name        = "example-ingress"
    #namespace   = "default"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }
  spec {
    rule {
      host = "*.example.com"
      http {
        path {
          path = "/"
            backend {
              service {
                name = "demoapp-lb-service"
                 port {
                   number = 80
                 }
              }
            }
        }
      }
    }
  }
}