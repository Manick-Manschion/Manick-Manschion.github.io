# Mänick Mänschion website (Manick-Manschion.github.io)

Static GitHub Pages site for the MOAS / Mänick Mänschion SDL2 port.

## Standing rules
- Mirror the structure of kurvenrausch.github.io: Nix flake pulls packages
  from the game flake (`git+https://github.com/Grumbel/moas`), assembles
  `index.html` + `images/` + `play/` (WASM) + `downloads/`.
- Site-only repo: no game sources. WASM = `manick.packages.${system}.manick-wasm`.
- Author commits as: Ingo Ruhnke <grumbel@gmail.com>
- Trailer: one Co-authored-by line naming the model that actually did the
  work, e.g. `Co-authored-by: Claude Opus 5.5 <noreply@anthropic.com>` or
  `Co-authored-by: Grok <grok@x.ai>`.
- Document progress in TODO.md and commit when a piece of work is done.
  Agents with repository access commit directly; only Grok Web, which
  can't, delivers cumulative git bundles instead.
- License: site scaffolding freely usable; game is GPL-2.0-or-later.

## Key files
- `flake.nix` — input manick (Grumbel/moas), builds site derivation
- `index.html` — landing page; `@version@` substituted at build time
- `.github/workflows/pages.yml` — nix build + deploy-pages
