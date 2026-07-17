{
  description = "Blue Prince Parlor Puzzle solver skill for Claude Code, OpenCode, and Pi";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.callPackage ./nix/package.nix { };
          blue-prince-parlor-solver-skill = self.packages.${system}.default;
        });

      checks = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          validate = pkgs.runCommand "blue-prince-parlor-solver-validate" { } ''
            cp -R ${self} source
            chmod -R u+w source
            cd source
            ${pkgs.bash}/bin/bash scripts/validate-skill.sh
            touch $out
          '';
        });

      nixosModules.default = import ./nix/nixos-module.nix;
      homeManagerModules.default = import ./nix/home-manager-module.nix;
    };
}
