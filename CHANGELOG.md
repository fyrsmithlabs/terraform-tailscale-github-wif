# Changelog

All notable changes to this component are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - 2026-09-06

### Added

- Initial release.
- `tailscale_federated_identity` per GitHub owner, keyed on the owner login and gated on
  the immutable `repository_owner_id` claim.
- `subject` defaults to `repo:<owner>*` so it matches both the legacy and the post
  2026-07-15 immutable GitHub OIDC `sub` shapes.
- Optional per-owner `subject` and `ref` overrides.
- Least-privilege defaults: `federated_identity_scopes = ["auth_keys"]`,
  `federated_identity_tags = ["tag:ci"]`.
- Plan-time validation that every `github_owners` entry carries a numeric `owner_id`.
- Outputs for the per-owner federated identity Client ID, Tailscale-generated audience, and
  effective subject pattern.
- README covering the threat model, fork/PR analysis, ref-restriction trade-off, required
  provider scopes, and an Atmos catalog stanza using declared `op://` secrets.

[Unreleased]: https://github.com/fyrsmithlabs/terraform-tailscale-github-wif/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/fyrsmithlabs/terraform-tailscale-github-wif/releases/tag/v0.1.0
