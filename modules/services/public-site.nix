{ config, lib, pkgs, ... }:

let
  siteRoot = ../../assets/public-site;
  documentsRoot = ../../documents;
in
{
  systemd.tmpfiles.rules = [
    "d /srv/state/public-site 0755 caddy caddy - -"
  ];

  system.activationScripts.publicSite = ''
    ${pkgs.coreutils}/bin/install -d -m 0755 -o caddy -g caddy /srv/state/public-site
    ${pkgs.rsync}/bin/rsync -a --delete --chmod=D755,F644 ${siteRoot}/ /srv/state/public-site/
    ${pkgs.coreutils}/bin/install -m 0644 -o caddy -g caddy ${documentsRoot}/resume/Resume.pdf /srv/state/public-site/rishabh-goel-resume.pdf
    ${pkgs.coreutils}/bin/chown -R caddy:caddy /srv/state/public-site
  '';
}
