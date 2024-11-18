{
  description = "Cheatshield Face Detect";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixgl.url = "github:guibou/nixGL";
  };

  outputs = { self, nixpkgs, flake-utils, nixgl }:
    flake-utils.lib.eachDefaultSystem (system: 
    let
      pkgs = nixpkgs.legacyPackages.${system};
      nixGLPkgs = nixgl.packages.${system};
    in
    {
      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [
          nixGLPkgs.nixGLIntel
          uv
          python3
          stdenv.cc.cc.lib
          cmake
          pkg-config
          zlib
          dlib
          opencv4
          glib
          pango
          cairo
          libpng
          libjpeg
          giflib
          librsvg
          pixman
        ];

        LD_LIBRARY_PATH = with pkgs; lib.makeLibraryPath [
          mesa
          stdenv.cc.cc.lib
          zlib
          dlib
          opencv4
          glib
          pango
          cairo
          libpng
          libjpeg
          giflib
          librsvg
          pixman
        ];
      };
    });
}
