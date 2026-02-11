{
  description = "Portfolio website development environment";

  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";
  inputs.ai-tools.url = "github:numtide/nix-ai-tools";

  outputs =
    {
      self,
      nixpkgs,
      ai-tools,
    }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSupportedSystem =
        f:
        nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            pkgs = import nixpkgs { inherit system; };
            inherit system;
          }
        );
    in
    {
      devShells = forEachSupportedSystem (
        { pkgs, system }:
        {
          default = pkgs.mkShell {
            packages = [
              pkgs.bun
              pkgs.git-lfs
              ai-tools.packages.${system}.crush
            ];
          };
        }
      );
    };
}
