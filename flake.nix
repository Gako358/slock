{
  description = "MerrinX slock build";

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
              slock = prev.slock.overrideAttrs (old: {
                src = builtins.path {
                  path = ./.;
                  name = "slock";
                };
                buildInputs =
                  old.buildInputs
                  ++ [
                    prev.imlib2
                    prev.pkg-config
                    prev.xorg.libXrandr.dev
                    prev.xorg.libXext.dev
                    prev.glib.dev
                  ];
              });
            })
          ];
        };

        overlay = final: prev: {
          slock = prev.slock;
        };
      in rec {
        apps = {
          slock = {
            type = "app";
            program = "${defaultPackage}/bin/slock";
          };
        };

        devShell = pkgs.mkShell {
          name = "slock-dev";
          packages = with pkgs; [
            gcc
            pkg-config
            xorg.libXrandr
            xorg.libXext
            imlib2
          ];
        };

        packages.slock = pkgs.slock;
        defaultApp = apps.slock;
        defaultPackage = packages.slock;

        overlays = {
          default = overlay;
        };
      }
    );
}
