# TODO / Handoff — Manick-Manschion.github.io

## Base
- Empty / new repo: Manick-Manschion/Manick-Manschion.github.io
- Template: kurvenrausch/kurvenrausch.github.io
- Game: Grumbel/moas (`#moas-wasm` and port packages)
- Tip (bundle 001.1): `586de41` Initial Mänick Mänschion website scaffold
- Bundle: `manick-web-001.1-initial-scaffold-586de41.bundle` (complete history from empty)

## Done (this stack)
- Scaffold flake.nix pulling `git+https://github.com/Grumbel/moas`
  - packages used: moas-wasm, moas-win64-zip, moas-win32-zip, moas-android,
    moas-r36s-portmaster-zip, moas-dos-zip
  - site under `result/`: index.html, images/, play/, downloads/
- index.html adapted for Mänick Mänschion (hero screenshot, play button →
  play/index.html, download list for Windows/Android/R36S/DOS/Linux)
- pages.yml GitHub Action (same disk-free + nix + deploy-pages flow)
- scripts/serve.sh for local preview
- AGENTS.md, README.md, .gitignore

## Next
- Apply bundle to the empty github.io repo, push master.
- Generate flake.lock (`nix flake lock` or first `nix build`) on a machine
  with network; commit lock and push.
- Enable GitHub Pages → source: GitHub Actions.
- After game flake updates: `nix flake update moas` and push.
- Confirm WASM install layout (moas.html / index.html / .data) matches
  play/ links after a full build; adjust flake copy step if names differ.
- Optional: add more screenshots or a short “how to play” from game data.

## Notes
- Build is x86_64-linux only (Android NDK / cross).
- DOS zip copy is best-effort (`|| true`) so a missing moas-dos-zip does not
  fail the site derivation.
- Do not spend long CI test runs in the agent environment; hand over the
  bundle and let the maintainer build.
