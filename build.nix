{
  stdenv, lib,
  gnumake,
  strace,
  latex2html,
  html-tidy,
  texlive,
  perl,
  ghostscript_headless,
}:
let
  tex = (texlive.combine {
    inherit (texlive)
      scheme-full
      hyperref
  ;});
  fs = lib.fileset;
in stdenv.mkDerivation rec {
  pname = "tech-squares-govdocs";
  version = "1.0";

  src = fs.toSource {
    root = ./.;
    fileset = (fs.unions [
      ./Makefile
      ./bylaws.cls
      ./techlogo.gif
      ./local
      (fs.intersection
        (fs.fileFilter
          ({hasExt, ...}: (
            (hasExt "tex")  ||  # main sources
            (hasExt "perl")     # latex2html support for LaTeX packages
          ))
          ./.
        )
        (fs.gitTracked ./.)
      )
    ]);
  };

  buildInputs = [
    gnumake
    strace
    tex
    (latex2html.overrideAttrs (old: {
      buildInputs = old.buildInputs ++ [tex];
    }))
    html-tidy
    perl    # for ts-html-convert
    ghostscript_headless
  ];

  buildPhase = ''
    make
  '';

  installPhase = ''
    runHook preInstall
    mkdir $out
    make install-nix
    runHook postInstall
  '';

  TEXINPUTS = "${latex2html.out}/texinputs/:";
}
