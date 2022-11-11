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

# missing sc and ingress config

# Helm Resources

module "helm-rucio-daemons" {
  source = "../modules/reana"

  ns_name        = var.reana-ns
  release_name = var.reana_release_name
}