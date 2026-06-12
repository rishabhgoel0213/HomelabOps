# Website Deployment

This repo keeps the website reproducible without changing `README.md`, which is
the public GitHub profile page.

## Runtime

The site is plain static HTML/CSS served by Caddy in Docker Compose. Public
traffic reaches the VPS through Cloudflare Tunnel.

```bash
make deploy
```

That command compiles `Resume.typ` into `Resume.pdf` using local Typst if it is
installed, or the official Typst Docker image if it is not, then starts Caddy.

## Cloudflare Tunnel

This deployment uses a named Cloudflare Tunnel:

```text
therealrishabh-site
549cebc2-9ef7-4c7f-bfb1-dec19c2d95d8
```

The tunnel routes these hostnames:

```text
therealrishabh.com
www.therealrishabh.com
```

The tunnel credentials are intentionally not checked into git. They live on the
VPS at:

```text
~/.cloudflared/549cebc2-9ef7-4c7f-bfb1-dec19c2d95d8.json
```

To recreate the Cloudflare side on a new VPS:

```bash
docker run --rm -it -v "$HOME/.cloudflared:/home/nonroot/.cloudflared" \
  cloudflare/cloudflared:latest tunnel login

docker run --rm -v "$HOME/.cloudflared:/home/nonroot/.cloudflared" \
  cloudflare/cloudflared:latest tunnel create therealrishabh-site

docker run --rm -v "$HOME/.cloudflared:/home/nonroot/.cloudflared" \
  cloudflare/cloudflared:latest tunnel route dns therealrishabh-site therealrishabh.com

docker run --rm -v "$HOME/.cloudflared:/home/nonroot/.cloudflared" \
  cloudflare/cloudflared:latest tunnel route dns therealrishabh-site www.therealrishabh.com
```

Then update `cloudflared/config.yml` with the new tunnel ID and credentials file
name.

## Direct DNS Alternative

The repo still includes `scripts/configure-cloudflare.py` for a direct `A` /
`CNAME` DNS setup, but the live deployment uses Cloudflare Tunnel.

## Moving VPSs

On the new host:

```bash
git clone https://github.com/rishabhgoel0213/rishabhgoel0213.git
cd rishabhgoel0213
make deploy
```
