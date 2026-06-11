set shell := ["bash", "-euo", "pipefail", "-c"]

host := env_var_or_default("HOST", "nixos-pc")

default:
    @just --list

check:
    nix flake check

build:
    sudo nixos-rebuild build --flake .#{{host}}

test:
    sudo nixos-rebuild test --flake .#{{host}}

switch:
    sudo nixos-rebuild switch --flake .#{{host}}

rollback:
    sudo nixos-rebuild switch --rollback

routes:
    nix eval --json .#nixosConfigurations.{{host}}.config.homelab.routeTable | jq .

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

cloudflare-login:
    cloudflared tunnel login

cloudflare-create-tunnel name:
    cloudflared tunnel create "{{name}}"

tailscale-ip:
    tailscale ip -4
