{
  description = "Cheatshield - Admin";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixGL = {
      url = "github:nix-community/nixGL/310f8e49a149e4c9ea52f1adf70cdc768ec53f8a";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, nixGL, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        nixGLIntel = nixGL.packages."${pkgs.system}".nixGLIntel;
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShell = pkgs.mkShell {
          LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib;${pkgs.glib.out}/lib";
          venvDir = "./.venv";
          buildInputs = (with pkgs; [
            nixGLIntel
            uv
            glib
          ]) ++ (with pkgs.python312Packages; [
            isort
            venvShellHook
          ]);
        };
      }
    );
}
