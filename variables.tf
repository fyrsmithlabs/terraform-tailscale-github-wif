variable "github_owners" {
  description = <<-EOT
    GitHub owners (orgs or user accounts) trusted to exchange an Actions OIDC
    token for a tailnet identity. One `tailscale_federated_identity` is created
    per map key — the key IS the owner login, matched exactly against the
    `repository_owner` claim.

    Per-owner attributes:
      owner_id — REQUIRED. The owner's numeric GitHub id, matched exactly
                 against the immutable `repository_owner_id` claim. This is the
                 real authorization gate; a renamed or typosquatted owner cannot
                 satisfy it. Get it with:
                   gh api orgs/<owner>  --jq .id   # organizations
                   gh api users/<owner> --jq .id   # user accounts
      subject  — OPTIONAL. Overrides the `sub` pattern. Defaults to
                 `repo:<owner>*`, which matches BOTH the legacy
                 `repo:<owner>/<repo>:...` shape and the post-2026-07-15
                 immutable `repo:<owner>@<owner_id>/<repo>@<repo_id>:...` shape.
                 `*` matches any run of characters; everything else is exact.
      ref      — OPTIONAL. Pins the `ref` claim (e.g. `refs/heads/main`).
                 Leave unset to allow pull-request runs, whose ref claim is
                 `refs/pull/<n>/merge`. See README.md § "Ref restrictions".
  EOT

  type = map(object({
    owner_id = string
    subject  = optional(string)
    ref      = optional(string)
  }))

  validation {
    condition     = alltrue([for o in var.github_owners : can(regex("^[0-9]+$", o.owner_id))])
    error_message = "Every github_owners entry needs a numeric owner_id (the immutable repository_owner_id claim). Fetch it with `gh api orgs/<owner> --jq .id` (or `users/<owner>` for a personal account) — do not guess, and do not leave a placeholder in place."
  }
}

variable "github_oidc_issuer" {
  description = "OIDC issuer URL Tailscale validates the `iss` claim against. GitHub Actions' issuer is the same for every repository and owner."
  type        = string
  default     = "https://token.actions.githubusercontent.com"
}

variable "federated_identity_scopes" {
  description = <<-EOT
    API scopes granted to the short-lived Tailscale token the exchange returns.
    `auth_keys` is the minimum that lets the runner mint the ephemeral auth key
    it joins the tailnet with, and it is deliberately the ONLY default — a
    stolen token cannot read devices, edit DNS, or touch the ACL. Widening this
    widens the blast radius of a leaked id-token exchange.
  EOT
  type        = list(string)
  default     = ["auth_keys"]
}

variable "federated_identity_tags" {
  description = <<-EOT
    Tags the federated identity may apply to nodes it authorizes. Whatever tag
    you use here is what your tailnet policy grants key off, so widening this
    list widens what a compromised runner can reach. Each tag must already have
    a `tagOwners` entry in the tailnet policy — this component does not create
    one.
  EOT
  type        = list(string)
  default     = ["tag:ci"]
}
