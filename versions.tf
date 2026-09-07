terraform {
  required_version = ">= 1.5"

  required_providers {
    # Declares the GitHub Actions → tailnet workload identity federation trust
    # (`tailscale_federated_identity`). Kept on the same constraint as the
    # terraform-tailscale-dns component so a stack using both resolves one
    # lockfile-compatible provider version.
    tailscale = {
      source  = "tailscale/tailscale"
      version = "~> 0.29"
    }
  }
}
