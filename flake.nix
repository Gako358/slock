{
  description = "MerrinX slock build";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: 
      let
        system = "x86_64-linux";
	overlay = final: prev: {
	  slock = prev.st.overrideAttrs (oldAttrs: rec {
	    version = "main";
	    src = builtins.path { path = ./.; name = "st"; };
	    buildInputs = oldAttrs.buildInputs ++ [
        prev.xorg.libXrandr.dev
        prev.xorg.libxext.dev
        prev.imlib2
	    ];
	  });
	};
	in
	rec {
	  overlays.default = overlay;
	  checks.${system}.build = (
            import nixpkgs {
	      inherit system;
	      overlays = [ overlay ];
	    }
	  ).slock;
	};
}
