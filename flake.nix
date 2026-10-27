# SPDX-FileCopyrightText: 2026 Ingo Ruhnke <grumbel@gmail.com>
# SPDX-License-Identifier: GPL-3.0-or-later
#
# Mänick Mänschion website: static landing page + WASM and the
# downloadable ports (Windows, Android, R36S, DOS) from the game flake +
# GitHub Pages. Same shape as kurvenrausch.github.io / SuperTux-Origins.github.io.
#
#   nix build          # → result/ (index.html, images/, play/, downloads/)
#   nix run .#serve    # local preview
#
{
  description = "Mänick Mänschion website (WASM + GitHub Pages), Nix-first";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    # git+https, not github: only a git fetch carries the commit count the
    # game's version may use (and matches how kurvenrausch-web pins its game).
    manick.url = "git+https://github.com/Grumbel/moas";
    manick.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, manick }:
    # x86_64-linux only: the Android SDK/NDK and some cross toolchains the
    # game's ports need are not packaged for other hosts.
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        game = manick.packages.${system};
        version = game.manick.version or "0.1.0-sdl";

        site = pkgs.runCommand "manick-manschion-site" { } ''
          mkdir -p $out
          substitute ${./index.html} $out/index.html --subst-var-by version ${version}
          cp -rv ${./images} $out/images

          # Playable WASM build from the game flake (html/js/wasm + data).
          mkdir -p $out/play
          cp -rv ${game.manick-wasm}/. $out/play/
          chmod -R u+w $out/play

          # Cache busting: GitHub Pages serves everything with max-age=600,
          # so right after a deploy a browser could pair a cached manick.js
          # with a fresh manick.wasm/manick.data (or the reverse). Version each
          # URL by content hash; unchanged files keep their URL and cache.
          ver() { sha256sum "$out/play/$1" | cut -c1-12; }
          js=$(ver manick.js); wasm=$(ver manick.wasm); data=$(ver manick.data)
          for f in $out/play/index.html $out/play/manick.html; do
            substituteInPlace "$f" \
              --replace-fail 'src="manick.js"' "src=\"manick.js?v=$js\"" \
              --replace-fail 'var Module = {' "var Module = {
      locateFile: function(path, prefix) {
        var v = { 'manick.wasm': '$wasm', 'manick.data': '$data' }[path];
        return prefix + path + (v ? '?v=' + v : \"\");
      },"
          done

          # Ports under stable names so the page's links never change
          # (the version is shown on the page).
          mkdir -p $out/downloads/r36s
          cp -v ${game.manick-win64-zip}/*.zip $out/downloads/manick-win64.zip
          cp -v ${game.manick-win32-zip}/*.zip $out/downloads/manick-win32.zip
          cp -v ${game.manick-android}/*.apk $out/downloads/manick.apk
          cp -v ${game.manick-r36s-portmaster-zip}/*.zip $out/downloads/r36s/manick.zip
          cp -v ${game.manick-dos-zip}/*.zip $out/downloads/manick-dos.zip
          chmod -R u+w $out/downloads
        '';

        serveApp = {
          type = "app";
          program = toString (pkgs.writeShellScript "serve-manick-site" ''
            export PKG=${site}
            export PATH=${pkgs.python3}/bin:${pkgs.xdg-utils}/bin:$PATH
            exec bash ${./scripts/serve.sh} "$@"
          '');
          meta.description = "Serve the Mänick Mänschion site and open it in a browser";
        };
      in {
        packages = {
          default = site;
          site = site;
        };

        apps = {
          default = serveApp;
          serve = serveApp;
        };
      });
}
