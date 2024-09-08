{
  description = "A flake for installing norpie's dmenu build";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (final: prev: {
              dmenu-norpie = prev.dmenu.overrideAttrs (oldAttrs: rec {
                version = "master";
                src = ./.;
              });
            })
          ];
        };
      in rec {
        apps = {
          dmenu = {
            type = "app";
            program = "${defaultPackage}/bin/dmenu";
          };
          dmenu_run = {
            type = "app";
            program = "${defaultPackage}/bin/dmenu_run";
          };
          dmenu_path = {
            type = "app";
            program = "${defaultPackage}/bin/dmenu_path";
          };
        };

        packages.dmenu-norpie = pkgs.dmenu-norpie;
        defaultApp = apps.dmenu;
        defaultPackage = pkgs.dmenu-norpie;

        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [xorg.libX11 xorg.libXft gcc];
        };
      }
    );
}
