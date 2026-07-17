{ lib, stdenvNoCC }:

stdenvNoCC.mkDerivation {
  pname = "blue-prince-parlor-solver-skill";
  version = "0.1.0";

  src = lib.cleanSource ../.;

  dontBuild = true;

  installPhase = ''
    runHook preInstall


    mkdir -p $out/share/agent-skills
    cp -R skills/blue-prince-parlor-solver $out/share/agent-skills/

    mkdir -p $out/bin
    cp scripts/install.sh $out/bin/blue-prince-parlor-solver-install
    cp scripts/validate-skill.sh $out/bin/blue-prince-parlor-solver-validate
    chmod +x $out/bin/blue-prince-parlor-solver-install
    chmod +x $out/bin/blue-prince-parlor-solver-validate

    runHook postInstall
  '';

  meta = {
    description = "Agent skill for solving Blue Prince Parlor Puzzle box riddles";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
