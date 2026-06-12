set shell := ["bash", "-eo", "pipefail", "-c"]

host := env_var_or_default("HOST", "nixos-pc")

default:
    @just --list

check:
    nix flake check --impure

build:
    sudo nixos-rebuild build --impure --flake .#{{host}}

test:
    sudo nixos-rebuild test --impure --flake .#{{host}}

switch:
    sudo nixos-rebuild switch --impure --flake .#{{host}}

rollback:
    sudo nixos-rebuild switch --rollback

routes:
    nix eval --impure --json .#nixosConfigurations.{{host}}.config.homelab.routeTable | jq .

route-add name visibility upstream:
    scripts/add-route "{{name}}" "{{visibility}}" "{{upstream}}"

route-remove name:
    scripts/remove-route "{{name}}"

logs service:
    journalctl -u "{{service}}" -f

status:
    systemctl --no-pager --failed
    systemctl --no-pager status caddy.service || true
    systemctl --no-pager status tailscaled.service || true
    systemctl --no-pager status docker.service || true

backup-now:
    sudo systemctl start restic-backups-homelab.service

secrets-edit:
    sudo env SOPS_AGE_KEY_CMD='/run/current-system/sw/bin/ssh-to-age -private-key -i /etc/ssh/ssh_host_ed25519_key' sops secrets/homelab.yaml

secrets-check:
    sudo env SOPS_AGE_KEY_CMD='/run/current-system/sw/bin/ssh-to-age -private-key -i /etc/ssh/ssh_host_ed25519_key' sops --decrypt secrets/homelab.yaml >/dev/null

cloudflare-store-token:
    scripts/store-cloudflare-token

cloudflare-store-token-from-env:
    scripts/store-cloudflare-dns-token-from-env

cloudflare-login:
    cfctl tunnel-login

cloudflare-create-tunnel name:
    cfctl tunnel-create "{{name}}"

cloudflare-verify:
    cfctl verify

cloudflare-zones:
    cfctl zones

cloudflare-dns:
    cfctl dns

tailscale-ip:
    tailscale ip -4

tailscale-store-oauth:
    scripts/store-tailscale-oauth

tailscale-verify:
    tsctl verify

tailscale-devices:
    tsctl devices

tailscale-dns:
    tsctl dns-nameservers

tailscale-split-dns:
    tsctl api GET /tailnet/-/dns/split-dns

tailscale-apply-internal-dns:
    scripts/configure-tailscale-internal-dns

vaultwarden-signups action:
    scripts/set-vaultwarden-signups "{{action}}"

github-profile-sync:
    scripts/sync-github-profile
