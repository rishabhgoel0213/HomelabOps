{ config, lib, pkgs, ... }:

{
  systemd.tmpfiles.rules = [
    "d /srv/ops 0755 rishabh users - -"
    "d /srv/state 0755 root root - -"
    "d /srv/state/public-site 0755 caddy caddy - -"
    "d /srv/state/backrest 0700 root root - -"
    "d /home/rishabh/Projects 0755 rishabh users - -"
    "d /home/rishabh/Remote 0755 rishabh users - -"
  ];
}
