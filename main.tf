resource "kubernetes_namespace" "hello" {
  metadata {
     name = "x"
  }
}

resource "kubernetes_deployment" "hello" {
  metadata {
    name = "terraform-example"
    labels = {
      test = "MyExampleApp"
    }
     namespace = "x"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        test = "MyExampleApp"
      }
    }

    template {
      metadata {
        labels = {
          test = "MyExampleApp"
        }
      }

      spec {
        container {
          image = "hello:0.1.0"
          name  = "example"
          port {
            container_port = 8080
          }
        }
      }
    }
  }
}