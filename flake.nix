{
  description = "MerrinX slock build";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    ,
    }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (final: prev: {
              slockMX = prev.slock.overrideAttrs (oldAttrs: rec {
				src = builtins.path {
					path = ./.;
					name = "slockMX";
				};
                buildInputs = 
					oldAttrs.buildInputs
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
      in
      rec {
        apps = {
          slock = {
            type = "app";
            program = "${defaultPackage}/bin/st";
          };
        };

        packages.slockMX = pkgs.slockMX;
        defaultApp = apps.st;
        defaultPackage = pkgs.slockMX;

        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [ xorg.libXrandr.dev xorg.libXext.dev glib.dev gcc pkgconfig imlib2 ];
        };
      }
    );
}
