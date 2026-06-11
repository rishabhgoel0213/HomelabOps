# Static Site Lab

Use this for one-off static pages.

```bash
cd /srv/lab
cp -r /srv/ops/lab-templates/static-site my-page
cd my-page
python3 -m http.server 3000 --bind 127.0.0.1
```

Then publish it:

```bash
cd /srv/ops
just route-add my-page internal http://127.0.0.1:3000
just switch
```
