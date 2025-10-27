let
  pkgs = import <nixpkgs> { config = {}; overlays = []; };
in
{
  govdocs = pkgs.callPackage ./build.nix { };
}
