# TODO / Handoff — Manick-Manschion.github.io

## Base
- Empty / new repo: Manick-Manschion/Manick-Manschion.github.io
- Template: kurvenrausch/kurvenrausch.github.io
- Game: Grumbel/moas (`#moas-wasm` and port packages)
- Tip (bundle 001.1): `586de41` Initial Mänick Mänschion website scaffold
- Bundle: `manick-web-001.1-initial-scaffold-586de41.bundle` (complete history from empty)

## Cache busting for play/ (2026-10-21)
- GitHub Pages sends `max-age=600` with no versioned URLs, so after a deploy
  a cached moas.js could meet a fresh moas.wasm/moas.data. The site build now
  appends `?v=<sha256[:12]>` to moas.js (script tag) and, via an injected
  `Module.locateFile`, to moas.wasm/moas.data, in play/index.html and moas.html.
- Checked: headless Firefox requests all three with `?v=`, 200 each.
- Left: a stale cached play/index.html (≤10 min) still names old hashes.
  Landing-page images and downloads are unversioned, which is harmless.

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

## Page update (2026-10-21)
- Screenshot re-taken from the SDL port without window decoration (960×600,
  English, front door); same image in the game's `docs/screenshot.png`.
- Added a portrait touch-controls screenshot (`images/screenshot-portrait.png`)
  next to the Controls text.
- Android requirement corrected to 5.1 (minSdk 22 in the game flake).
- Controls: F5/F7, Esc/Shift, F12 options (English translation), Alt+Q.

## Page update (2026-10-27)
- Translations: ES, FR, IT, NL besides EN (incl. title cards, help pages,
  credits); language follows the OS; switch via F12 / Options button.
- Controls: H hotspot hint, F11 / Alt+Enter fullscreen, Tab inventory,
  two-page F12 menu (save/load/restart/quit + settings, persisted).
- Touch buttons renamed as in the game (Options, Hint, Skip Scene, Skip Text).
- Dropped the "may be missing" note on the DOS zip (the flake requires it).
- Screenshots not re-taken.

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
- The DOS zip is copied like the other ports; a failing moas-dos-zip build
  fails the site build.
- Do not spend long CI test runs in the agent environment; hand over the
  bundle and let the maintainer build.
