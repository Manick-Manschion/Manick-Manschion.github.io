# TODO / Handoff — Manick-Manschion.github.io

## Base
- Empty / new repo: Manick-Manschion/Manick-Manschion.github.io
- Template: kurvenrausch/kurvenrausch.github.io
- Game: Grumbel/moas (`#manick-wasm` and port packages)
- Tip (bundle 001.1): `586de41` Initial Mänick Mänschion website scaffold
- Bundle: `manick-web-001.1-initial-scaffold-586de41.bundle` (complete history from empty)

## Cache busting for play/ (2026-10-21)
- GitHub Pages sends `max-age=600` with no versioned URLs, so after a deploy
  a cached manick.js could meet a fresh manick.wasm/manick.data. The site build now
  appends `?v=<sha256[:12]>` to manick.js (script tag) and, via an injected
  `Module.locateFile`, to manick.wasm/manick.data, in play/index.html and manick.html.
- Checked: headless Firefox requests all three with `?v=`, 200 each.
- Left: a stale cached play/index.html (≤10 min) still names old hashes.
  Landing-page images and downloads are unversioned, which is harmless.

## Follow the game's moas → manick rename (2026-10-27)
- Game commit 35c534b renamed the flake packages (`moas-*` → `manick-*`) and
  all distribution files; the lock bump to 4e7977b broke `nix build` with
  "attribute 'moas-wasm' missing".
- flake.nix uses `manick-wasm`, `manick-win64-zip`, … and the WASM files
  `manick.{html,js,wasm,data}`; `version` reads `game.manick.version` (the
  old `game.moas` fell back silently to "0.1.0-sdl").
- Downloads now ship as `manick-win64.zip`, `manick-win32.zip`, `manick.apk`,
  `r36s/manick.zip`, `manick-dos.zip`; old `moas*` download URLs are gone.
  The flake input is renamed to `manick` too; only the repo URL (Grumbel/moas)
  and references to the MOAS engine keep the old name.

## Done (this stack)
- Scaffold flake.nix pulling `git+https://github.com/Grumbel/moas`
  - packages used: manick-wasm, manick-win64-zip, manick-win32-zip, manick-android,
    manick-r36s-portmaster-zip, manick-dos-zip
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
- After game flake updates: `nix flake update manick` and push.
- Confirm WASM install layout (manick.html / index.html / .data) matches
  play/ links after a full build; adjust flake copy step if names differ.
- Optional: add more screenshots or a short “how to play” from game data.

## Notes
- Build is x86_64-linux only (Android NDK / cross).
- The DOS zip is copied like the other ports; a failing manick-dos-zip build
  fails the site build.
- Do not spend long CI test runs in the agent environment; hand over the
  bundle and let the maintainer build.
