# SPDX-FileCopyrightText: 2026 Ingo Ruhnke <grumbel@gmail.com>
# SPDX-License-Identifier: GPL-3.0-or-later
#
# Mänick Mänschion / MOAS website: static landing page + WASM and the
# downloadable ports (Windows, Android, R36S, DOS) from the game flake +
# GitHub Pages. Same shape as kurvenrausch.github.io / SuperTux-Origins.github.io.
#
#   nix build          # → result/ (index.html, images/, play/, downloads/)
#   nix run .#serve    # local preview
#
{
  description = "Mänick Mänschion website (MOAS WASM + GitHub Pages), Nix-first";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    # git+https, not github: only a git fetch carries the commit count the
    # game's version may use (and matches how kurvenrausch-web pins its game).
    moas.url = "git+https://github.com/Grumbel/moas";
    moas.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, moas }:
    # x86_64-linux only: the Android SDK/NDK and some cross toolchains the
    # game's ports need are not packaged for other hosts.
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        game = moas.packages.${system};
        version = game.moas.version or "0.1.0-sdl";

        site = pkgs.runCommand "manick-manschion-site" { } ''
          mkdir -p $out
          substitute ${./index.html} $out/index.html --subst-var-by version ${version}
          cp -rv ${./images} $out/images

          # Playable WASM build from the game flake (html/js/wasm + data).
          mkdir -p $out/play
          cp -rv ${game.moas-wasm}/. $out/play/
          chmod -R u+w $out/play

          # Ports under stable names so the page's links never change
          # (the version is shown on the page).
          mkdir -p $out/downloads/r36s
          cp -v ${game.moas-win64-zip}/*.zip $out/downloads/moas-win64.zip
          cp -v ${game.moas-win32-zip}/*.zip $out/downloads/moas-win32.zip
          cp -v ${game.moas-android}/*.apk $out/downloads/moas.apk
          cp -v ${game.moas-r36s-portmaster-zip}/*.zip $out/downloads/r36s/moas.zip
          cp -v ${game.moas-dos-zip}/*.zip $out/downloads/moas-dos.zip
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
