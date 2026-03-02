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
scp index.html og-image.png root@webserver.skelpo.net:/var/www/hone.codes/
```

To regenerate `og-image.png` after editing `og-image.svg`:
```bash
rsvg-convert -w 1200 -h 630 og-image.svg -o og-image.png
```

### Server config

- **Nginx config:** `/etc/nginx/sites-enabled/hone.codes`
- **Web root:** `/var/www/hone.codes/`
- **SSL:** Let's Encrypt via Certbot (auto-renews)

## Perry Server Notes

`server.ts` uses Perry's low-level HTTP FFI (`declare function js_http_server_*`). These symbols live in `perry-stdlib`, so a stdlib import (`import {} from 'uuid'`) is included to trigger stdlib linking — without it the linker can't find the HTTP server symbols.

## Style Guide

- All styles are CSS custom properties defined in `:root`
- Brand colors: `--accent: #00D4AA` (Hone Teal), `--accent-secondary: #00B4D8` (Hone Cyan), `--accent-dim: #0077B6` (Hone Blue)
- Dark theme backgrounds: `--bg-primary: #0D1117`, `--bg-secondary: #161B22`, `--bg-card: #1C2128`
- Fonts: Inter (UI/body) + JetBrains Mono (code), loaded from Google Fonts
- Animations: `fadeInUp` on load, `IntersectionObserver` for scroll reveals
- Brand assets live in `../hone-brand/` — colors, logos, guidelines

## Checking Progress & Updating the Page

When asked to check progress and update the landing page (Status section, Roadmap, Updates feed), do the following:

### 1. Scan all sibling packages

```bash
ls /Users/amlug/projects/hone/
```

For each package directory (`hone-core`, `hone-editor`, `hone-ide`, `hone-terminal`, `hone-api`, `hone-extensions`, `hone-themes`):

```bash
# Recent commits
git -C ../hone-editor log --oneline -10

# Current version
cat ../hone-editor/package.json | python3 -m json.tool | grep version

# What's newly implemented (look for README, CHANGELOG, or src/)
ls ../hone-editor/src/
```

### 2. Read the plan files for slice status

```
../INTEGRATED_PLAN.md   — 15-slice build plan with exact deliverables per slice
../hone-project-plan-v3.md — overall vision and differentiators
../hone-ide/src/        — check which slice files actually exist to determine completion
../hone-core/src/       — same
```

### 3. Update index.html in three places

- **Status section** (`id="status"`) — update version tags, badge states (`badge-done` / `badge-active` / `badge-planned`), and bullet points per package
- **Roadmap section** (`id="roadmap"`) — move slices from `planned` → `active` → `done` by updating `.slice-check` class and `.slice-name.planned` class; update phase-level badges too
- **Updates section** (`id="updates"`) — prepend a new `.update-post` with today's date, an accurate tag, a real title, and honest prose about what actually changed (no marketing language — see brand voice guidelines)

### 4. Slice completion signals

A slice is **done** when its IDE view files exist in `../hone-ide/src/workbench/views/` and its core files exist in `../hone-core/src/`. A slice is **active** if some files exist but not all. Use `ls` to check rather than guessing.
