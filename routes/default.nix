{ ... }:

{
  homelab.routes = builtins.fromJSON (builtins.readFile ./apps.json);
}
