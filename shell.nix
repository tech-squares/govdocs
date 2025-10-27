# shell.nix
{ pkgs ? import <nixpkgs> {} }:
let
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive)
      scheme-full
      hyperref
  ;});
in
pkgs.mkShellNoCC {
  buildInputs = with pkgs; [
    gnumake
    (latex2html.overrideAttrs (old: {
      buildInputs = old.buildInputs ++ [tex];
    }))
    html-tidy
    tex
    perl    # for ts-html-convert
    ghostscript_headless
  ];

  TEXINPUTS = "${pkgs.latex2html.out}/texinputs/:";
}
