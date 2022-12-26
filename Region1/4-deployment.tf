// DEPLOYMENT of app on eks using the k8s module
resource "kubernetes_deployment" "example" {
  metadata {
    name = "terraform-deployment"
    labels = {
      test = "busybox"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        test = "busybox"
      }
    }

    template {
      metadata {
        labels = {
          test = "busybox"
        }
      }

      spec {
        container {
          image = "busybox:latest"
          name  = "busybox"

          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "example" {
  metadata {
    name = "terraform-lb-service"
  }
  spec {
    selector = {
      test = "busybox"
    }
    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}
