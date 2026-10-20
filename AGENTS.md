# Mänick Mänschion website (Manick-Manschion.github.io)

Static GitHub Pages site for the MOAS / Mänick Mänschion SDL2 port.

## Standing rules
- Mirror the structure of kurvenrausch.github.io: Nix flake pulls packages
  from the game flake (`git+https://github.com/Grumbel/moas`), assembles
  `index.html` + `images/` + `play/` (WASM) + `downloads/`.
- Site-only repo: no game sources. WASM = `moas.packages.${system}.moas-wasm`.
- Author commits as: Ingo Ruhnke <grumbel@gmail.com>
- Trailer: Co-authored-by: Grok <grok@x.ai>
- Document progress in TODO.md; deliver cumulative git bundles.
- License: site scaffolding freely usable; game is GPL-2.0-or-later.

## Key files
- `flake.nix` — inputs moas, builds site derivation
- `index.html` — landing page; `@version@` substituted at build time
- `.github/workflows/pages.yml` — nix build + deploy-pages
