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
  }: let
    overlay = final: prev: {
      slock = prev.slock.overrideAttrs (oldAttrs: rec {
        src = builtins.path {
          path = ./.;
          name = "slock";
        };
        buildInputs =
          oldAttrs.buildInputs
          ++ [
            prev.imlib2
            prev.pkg-config
            prev.xorg.libXrandr
            prev.xorg.libXext
          ];
      });
    };
  in
    flake-utils.lib.eachDefaultSystem
    (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            self.overlays.default
          ];
        };
      in rec {
        packages.slock = pkgs.slock;
        packages.default = pkgs.slock;
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            gcc
            pkgconfig
            imlib2
            xorg.libX11
            xorg.libXft
            xorg.libXinerama
          ];
        };
      }
    )
    // {overlays.default = overlay;};
}
