{ config, lib, pkgs, ... }:

{
  systemd.tmpfiles.rules = [
    "d /srv/ops 0755 rishabh users - -"
    "d /srv/state 0755 root root - -"
    "d /srv/data 0755 rishabh users - -"
    "d /srv/lab 0755 rishabh users - -"
    "d /srv/backups 0750 root root - -"
    "d /srv/state/public-site 0755 caddy caddy - -"
    "d /srv/state/backrest 0700 root root - -"
  ];
}
