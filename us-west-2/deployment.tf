resource "kubernetes_deployment" "busybox-deployment" {
  metadata {
    name = "busybox"
    labels = {
      name = "busybox"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        name = "busybox"
      }
    }

    template {
      metadata {
        labels = {
          name = "busybox"
        }
      }

      spec {
        container {
          image = "busybox:latest"
          name = "busybox"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

        }
      }
    }
  }
}