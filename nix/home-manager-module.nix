{ config, lib, pkgs, ... }:

let
  cfg = config.programs.bluePrinceParlorSolverSkill;
  skillName = "blue-prince-parlor-solver";
  skillSource = "${cfg.package}/share/agent-skills/${skillName}";
  hasTarget = target: builtins.elem target cfg.installFor;
in
{
  options.programs.bluePrinceParlorSolverSkill = {
    enable = lib.mkEnableOption "Blue Prince Parlor Solver agent skill";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.callPackage ./package.nix { };
      defaultText = lib.literalExpression "pkgs.callPackage ./package.nix { }";
      description = "Package that provides the Blue Prince Parlor Solver skill.";
    };

    installFor = lib.mkOption {
      type = lib.types.listOf (lib.types.enum [ "claude" "opencode" "pi" "agents" ]);
      default = [ "claude" "opencode" "pi" "agents" ];
      description = "Agent skill locations to populate.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    home.file = lib.mkMerge [
      (lib.mkIf (hasTarget "claude") {
        ".claude/skills/${skillName}".source = skillSource;
      })
      (lib.mkIf (hasTarget "opencode") {
        ".config/opencode/skills/${skillName}".source = skillSource;
      })
      (lib.mkIf (hasTarget "pi") {
        ".pi/agent/skills/${skillName}".source = skillSource;
      })
      (lib.mkIf (hasTarget "agents") {
        ".agents/skills/${skillName}".source = skillSource;
      })
    ];
  };
}
