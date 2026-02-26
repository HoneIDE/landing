# Hone Landing Page

The landing page for [hone.codes](https://hone.codes) — a native, AI-powered code editor written in TypeScript and compiled to native binaries via [Perry](https://perryts.com).

## Stack

- **Single-file HTML** — all CSS and JS inlined, zero dependencies, zero build step
- **Perry HTTP server** — `server.ts` compiles to a native binary via Perry for local dev
- **nginx + Let's Encrypt** — static file serving with HTTPS in production

## Development

Any static file server works:

```bash
npx serve .
```

Or use the Perry native server (requires Perry built at `../../perry`):

```bash
cargo run --release --manifest-path ../../perry/Cargo.toml -- server.ts -o server
./server
# → http://localhost:3000
```

## Deploy

```bash
scp index.html root@webserver.skelpo.net:/var/www/hone.codes/index.html
```

## About Hone

Hone is an AI-first, native code editor — no Electron, no Chromium, no V8. Written in TypeScript, compiled to native via Perry. Targets macOS, Windows, Linux, iOS, Android, and Web from a single codebase.

- Website: [hone.codes](https://hone.codes)
- Compiler: [perryts.com](https://perryts.com)
- GitHub: [github.com/HoneIDE](https://github.com/HoneIDE)
