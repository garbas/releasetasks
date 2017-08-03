{ pkgs ? import <nixpkgs> {}
}:


let

  inherit (pkgs.lib)
    fileContents
    removeSuffix
    splitString
    ;

  startsWith = s: x:
    builtins.substring 0 (builtins.stringLength x) s == x;

  fromRequirementsFile = file: custom_pkgs:
    let
      removeLines =
        builtins.filter
          (line: ! startsWith line "-r" && line != "" && ! startsWith line "#");

      removeAfter =
        delim: line:
          let
            split = splitString delim line;
          in
            if builtins.length split > 1
              then builtins.head split
              else line;

      removeExtras =
        builtins.map (removeAfter "[");

      removeSpecs =
        builtins.map
          (line:
            (removeAfter "<" (
              (removeAfter ">" (
                (removeAfter ">=" (
                  (removeAfter "<=" (
                    (removeAfter "==" line))
                  ))
                ))
              ))
            ));

      extractEggName =
        map
          (line:
            let
              split = splitString "egg=" line;
            in
              if builtins.length split == 2
                then builtins.elemAt split 1
                else line
          );

      readLines = file_:
        (splitString "\n"
          (removeSuffix "\n"
            (builtins.readFile file_)
          )
        );
    in
      map
        (pkg_name: builtins.getAttr pkg_name custom_pkgs)
        (removeExtras
          (removeSpecs
            (removeLines
              (extractEggName
                (readLines file)))));

  version = fileContents ./VERSION;
  python = import ./requirements.nix { inherit pkgs; };

in python.mkDerivation {
  name="releasetasks-${version}";
  src = ./.;
  buildInputs = fromRequirementsFile ./requirements-dev.txt python.packages;
  propagatedBuildInputs = fromRequirementsFile ./requirements.txt python.packages;
  doCheck = true;
  checkPhase = ''
    flake8 setup.py releasetasks
    pytest --verbose -n8 --doctest-modules releasetasks
  '';
  passthru.python = python;
}
