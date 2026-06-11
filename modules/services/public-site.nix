{ config, lib, pkgs, ... }:

let
  index = pkgs.writeText "therealrishabh-index.html" ''
    <!doctype html>
    <html lang="en">
      <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Rishabh Goel</title>
        <style>
          :root {
            color-scheme: light dark;
            font-family: ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
          }
          body {
            margin: 0;
            min-height: 100vh;
            display: grid;
            place-items: center;
            background: #0f172a;
            color: #f8fafc;
          }
          main {
            width: min(720px, calc(100vw - 48px));
          }
          h1 {
            margin: 0 0 12px;
            font-size: clamp(2.25rem, 8vw, 5rem);
            line-height: 1;
          }
          p {
            margin: 0;
            color: #cbd5e1;
            font-size: 1.1rem;
            line-height: 1.6;
          }
        </style>
      </head>
      <body>
        <main>
          <h1>Rishabh Goel</h1>
          <p>Personal site and project gateway.</p>
        </main>
      </body>
    </html>
  '';
in
{
  systemd.tmpfiles.rules = [
    "C /srv/state/public-site/index.html 0644 caddy caddy - ${index}"
  ];
}
