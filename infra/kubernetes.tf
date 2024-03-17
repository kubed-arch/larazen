data "digitalocean_kubernetes_versions" "kubernetes-version" {
  version_prefix = "2.36.0"
}

data "digitalocean_sizes" "small" {
  filter {
    key    = "slug"
    values = ["s-2vcpu-2gb"]
  }
}

resource "digitalocean_kubernetes_cluster" "laravel-in-kubernetes" {
  name = "laravel-in-kubernetes"
  region = var.do_region

  version = data.digitalocean_kubernetes_versions.kubernetes-version.latest_version

  auto_upgrade = true
  maintenance_policy {
    start_time = "04:00"
    day = "sunday"
  }

  node_pool {
    name = "default-pool"
    size = "${element(data.digitalocean_sizes.small.sizes, 0).slug}"
    auto_scale = true
    min_nodes = 1
    max_nodes = 5

    labels = {
      pool = "default"
      size = "small"
    }
  }
}