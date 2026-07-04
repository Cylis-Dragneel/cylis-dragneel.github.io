let
  sources = import ./npins;
  pkgs = import sources.nixpkgs {};
in
  pkgs.mkShell {
    packages = [ pkgs.bun ];
  }
