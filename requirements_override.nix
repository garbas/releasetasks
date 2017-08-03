{ pkgs, python }:

self: super: {

  "execnet" = python.overrideDerivation super."execnet" (old: {
    patchPhase = ''
      sed -i -e "s|setup_requires=\['setuptools_scm'\],||" setup.py
    '';
  });

  "flake8" = python.overrideDerivation super."flake8" (old: {
    patchPhase = ''
      sed -i -e "s|setup_requires=\['pytest-runner'\],||" setup.py
    '';
  });

  "mccabe" = python.overrideDerivation super."mccabe" (old: {
    patchPhase = ''
      sed -i -e "s|setup_requires=\['pytest-runner'\],||" setup.py
    '';
  });

  "pytest" = python.overrideDerivation super."pytest" (old: {
    patchPhase = ''
      sed -i -e "s|setup_requires=\['setuptools-scm'\],||" setup.py
    '';
  });

  "pytest-xdist" = python.overrideDerivation super."pytest-xdist" (old: {
    patchPhase = ''
      sed -i -e "s|setup_requires=\['setuptools_scm'\],||" setup.py
      sed -i -e "s|install_requires=\['execnet>=1.1', 'pytest>=3.0.0'\]|install_requires=\['execnet', 'pytest'\]|" setup.py
    '';
  });

}
