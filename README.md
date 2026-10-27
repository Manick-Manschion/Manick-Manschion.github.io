# Mänick Mänschion website

Static site for [MOAS / Mänick Mänschion](https://github.com/Grumbel/moas),
structured like [kurvenrausch.github.io](https://github.com/kurvenrausch/kurvenrausch.github.io)
and [SuperTux-Origins.github.io](https://github.com/SuperTux-Origins/SuperTux-Origins.github.io):

- **Nix flake** pulls the playable **WASM** package (`github:Grumbel/moas#moas-wasm`)
  and the downloadable ports (Windows 64/32-bit zips, the Android APK, the R36S
  PortMaster zip, the DOS zip) from the game flake and assembles
  `index.html`, screenshots, `play/` and `downloads/` into a single store path;
  building the site builds them all
- **GitHub Pages** deploys that path via `.github/workflows/pages.yml`
- **Local preview**: `nix run .#serve`

## Layout

```
.
├── flake.nix                 # site only (WASM and ports come from Grumbel/moas)
├── index.html                # landing page
├── images/                   # screenshots (from the game docs/)
├── scripts/serve.sh          # local HTTP server (no-cache headers)
└── .github/workflows/pages.yml
```

## Commands

```bash
# Build the full site (HTML + WASM under play/)
nix build
ls result/
# result/index.html  result/images/  result/play/{index,moas}.{html,js,wasm,...}
# result/downloads/moas-win64.zip  moas-win32.zip  moas.apk
# result/downloads/r36s/moas.zip

# Build against a local checkout of the game instead of GitHub:
nix build --override-input moas git+file://$HOME/projects/moas

# Serve and open a browser (port 8765 by default)
nix run .
# or:
MANICK_PORT=9000 nix run .#serve
```

## GitHub Pages

1. Push this repository to GitHub (e.g. `Manick-Manschion/Manick-Manschion.github.io`).
2. Under **Settings → Pages**, set the source to **GitHub Actions**.
3. On every push to `master`, the workflow runs `nix build` and deploys
   `result/` with `actions/deploy-pages`.

The WASM build and the ports are built by the
[moas](https://github.com/Grumbel/moas) flake; this site only packages them.
The site follows the game revision in `flake.lock`: after pushing the game,
run `nix flake update moas` here and push to rebuild everything. The build
runs on x86_64-linux only (Android SDK and cross toolchains).

## License

Site scaffolding: use freely (same spirit as the Kurvenrausch site template).
Game binary / WASM: **GPL-2.0-or-later** (see [Grumbel/moas](https://github.com/Grumbel/moas)).
Screenshot under `images/` is from the game documentation.
