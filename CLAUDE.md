# CLAUDE.md

This file provides guidance to Claude Code when working with this repository.

## Project Overview

Static landing page for [Hone](https://hone.codes) — a native, AI-powered code editor built in TypeScript and compiled to native binaries via [Perry](https://perryts.com).

The site is a single self-contained `index.html` with all CSS and JS inlined (no build step, no dependencies).

## Files

| File | Purpose |
|------|---------|
| `index.html` | The landing page — all markup, styles, and scripts in one file |
| `server.ts` | Perry HTTP server to serve the page locally during development |

## Local Development

### Option 1: Perry server (matches production behavior)

Requires Perry (the native TypeScript compiler) at `../../perry` relative to this repo.

```bash
# Compile the server (only needed when server.ts changes)
cargo run --release --manifest-path ../../perry/Cargo.toml -- server.ts -o server

# Run
./server
# → http://localhost:3000
```

### Option 2: Any static file server

```bash
npx serve .
# or
python3 -m http.server 3000
```

## Deployment

The site is deployed to **https://hone.codes** via nginx on `webserver.skelpo.net`.

### Deploy an update

```bash
scp index.html root@webserver.skelpo.net:/var/www/hone.codes/index.html
```

### Server config

- **Nginx config:** `/etc/nginx/sites-enabled/hone.codes`
- **Web root:** `/var/www/hone.codes/`
- **SSL:** Let's Encrypt via Certbot (auto-renews)

## Perry Server Notes

`server.ts` uses Perry's low-level HTTP FFI (`declare function js_http_server_*`). These symbols live in `perry-stdlib`, so a stdlib import (`import {} from 'uuid'`) is included to trigger stdlib linking — without it the linker can't find the HTTP server symbols.

## Style Guide

- All styles are CSS custom properties defined in `:root`
- Color palette: dark theme with `--accent: #60dfb0` (green) and `--accent-secondary: #5090ff` (blue)
- Fonts: Outfit (display) + JetBrains Mono (code), loaded from Google Fonts
- Animations: `fadeInUp` on load, `IntersectionObserver` for scroll reveals
