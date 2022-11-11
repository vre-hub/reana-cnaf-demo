# Openstack Resources (canot be changed after apply due to limitations of the openstack tf provider)

resource "openstack_compute_keypair_v2" "openstack-keypair" {
  name = "cluster_kp-${var.cluster-resource-suffix}"
}

resource "openstack_containerinfra_cluster_v1" "openstack-cluster" {
  name                = "reana-cnaf-demo"
  cluster_template_id = "22a4c77f-cfe3-47bb-8006-31d02375a3f3"
  master_count        = 2
  node_count          = 4
  keypair             = var.openstack_keypair_name
  merge_labels        = true
  flavor              = "m2.2xlarge"
  master_flavor       = "m2.medium"
  labels = {
    # tbd
  }
}

# Kubernetes Resources

resource "kubernetes_namespace_v1" "ns-reana" {
  metadata {
    name = var.reana-ns
  }
}

resource "kubernetes_storage_class_v1" "reana-storage-class" {
  metadata {
    name = "${reana_release_name}-shared-volume-storage-class"
  }
  storage_provisioner = "fuseim.pri/ifs"
  parameters = {
    archiveOnDelete = "false"
  }
}

/* 
Exported via tfk8s from yml to hcl format to use as manifest resource:
kubectl get ingress reana-v2-ingress -o yaml -n reana| tfk8s --strip -o reana-ingress.tf
*/

resource "kubernetes_manifest" "reana_nginx_ingress" {
  manifest = {
    "apiVersion" = "networking.k8s.io/v1"
    "kind" = "Ingress"
    "metadata" = {
      "annotations" = {
        "ingress.kubernetes.io/ssl-redirect" = "true"
        "kubernetes.io/ingress.class" = "nginx"
        "traefik.frontend.entryPoints" = "http,https"
      }
      "name" = "${reana_release_name}-ingress"
      "namespace" = "reana"
    }
    "spec" = {
      "rules" = [
        {
          "http" = {
            "paths" = [
              {
                "backend" = {
                  "service" = {
                    "name" = "${reana_release_name}-server"
                    "port" = {
                      "number" = 80
                    }
                  }
                }
                "path" = "/api"
                "pathType" = "Prefix"
              },
              {
                "backend" = {
                  "service" = {
                    "name" = "${reana_release_name}-server"
                    "port" = {
                      "number" = 80
                    }
                  }
                }
                "path" = "/oauth"
                "pathType" = "Prefix"
              },
              {
                "backend" = {
                  "service" = {
                    "name" = "${reana_release_name}-ui"
                    "port" = {
                      "number" = 80
                    }
                  }
                }
                "path" = "/"
                "pathType" = "Prefix"
              },
            ]
          }
        },
      ]
      "tls" = [
        {
          "secretName" = "${reana_release_name}-tls-secret"
        },
      ]
    }
  }
}

# Helm Resources

module "helm-rucio-daemons" {
  source = "../modules/reana"

  ns_name        = var.reana-ns
  release_name = var.reana_release_name
}