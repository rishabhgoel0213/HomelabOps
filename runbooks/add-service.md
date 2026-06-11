# Add A Service

## Internal Service

Start the app bound to localhost or a Docker-only network, then add a route:

```bash
just route-add myapp internal http://127.0.0.1:3000
just routes
just switch
```

It will be reachable at:

```text
myapp.internal.therealrishabh.com
```

## Public Service

```bash
just route-add demo public http://127.0.0.1:3000
just routes
just switch
```

It will be reachable at:

```text
demo.therealrishabh.com
```

## Public Protected Service

Use `public-protected` for a service that should be internet-routable but guarded by Cloudflare Access or app-native auth:

```bash
just route-add admin public-protected http://127.0.0.1:3000
```

Then configure the matching Cloudflare Access application before sharing the URL.
