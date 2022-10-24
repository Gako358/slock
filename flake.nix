{
  description = "MerrinX slock build";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self
    , nixpkgs
    ,
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      overlay = final: prev: {
        slock = prev.st.overrideAttrs (oldAttrs: rec {
          version = "main";
          src = builtins.path {
            path = ./.;
            name = "slock";
          };
          buildInputs =
            oldAttrs.buildInputs
            ++ [
              prev.pkg-config
              prev.xorg.libXrandr.dev
              prev.xorg.libXext.dev
              prev.imlib2
            ];
        });
      };
    in
    rec {
      devShells.x86_64-linux.default = pkgs.mkShell {
        name = "slock-dev";
        packages = with pkgs; [
          gcc
          pkg-config
          xorg.libXrandr
          xorg.libXext
          imlib2
        ];
      };
      overlays.default = overlay;
      checks.${system}.build =
        (
          import nixpkgs {
            inherit system;
            overlays = [ overlay ];
          }
        ).slock;
    };
}
