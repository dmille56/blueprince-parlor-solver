{ config, lib, pkgs, ... }:

let
  cfg = config.programs.bluePrinceParlorSolverSkill;
  skillName = "blue-prince-parlor-solver";
  skillSource = "${cfg.package}/share/agent-skills/${skillName}";
  hasTarget = target: builtins.elem target cfg.installFor;
  users = lib.concatMapStringsSep " " lib.escapeShellArg cfg.users;
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
      description = "Agent skill locations to populate for each configured user.";
    };

    users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "alice" ];
      description = "Local users whose home directories should receive skill symlinks.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    system.activationScripts.bluePrinceParlorSolverSkill = lib.mkIf (cfg.users != [ ]) ''
      install_skill_link() {
        parent=$1
        dest=$parent/${skillName}
        mkdir -p "$parent"
        rm -rf "$dest"
        ln -s ${lib.escapeShellArg skillSource} "$dest"
      }

      for user in ${users}; do
        home_dir=$(getent passwd "$user" | cut -d: -f6 || true)
        if [ -z "$home_dir" ]; then
          echo "blue-prince-parlor-solver: skipping unknown user $user" >&2
          continue
        fi

        ${lib.optionalString (hasTarget "claude") ''
          install_skill_link "$home_dir/.claude/skills"
        ''}
        ${lib.optionalString (hasTarget "opencode") ''
          install_skill_link "$home_dir/.config/opencode/skills"
        ''}
        ${lib.optionalString (hasTarget "pi") ''
          install_skill_link "$home_dir/.pi/agent/skills"
        ''}
        ${lib.optionalString (hasTarget "agents") ''
          install_skill_link "$home_dir/.agents/skills"
        ''}

        chown -hR "$user" "$home_dir/.claude" "$home_dir/.config/opencode" "$home_dir/.pi" "$home_dir/.agents" 2>/dev/null || true
      done
    '';
  };
}
