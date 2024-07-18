{
  description = "My personal website (itsdrike.com)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = {nixpkgs, ...}: let
    inherit (nixpkgs) lib;
    pkgsFor = system: import nixpkgs {inherit system;};

    targetSystems = ["aarch64-linux" "x86_64-linux"];
  in {
    devShells = lib.genAttrs targetSystems (system: let
      pkgs = pkgsFor system;
    in {
      default = pkgs.mkShell {
        packages = with pkgs; [
          bash
          coreutils
          hugo
          nodePackages.npm
        ];
      };
    });

    formatter = lib.genAttrs targetSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
  };
}
