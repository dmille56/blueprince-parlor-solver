# Blue Prince Parlor Solver Skill

Agent skill for solving the Blue Prince Parlor Puzzle in Claude Code, OpenCode, and Pi coding agent.

The skill takes the words written on the blue, white, and black boxes and returns which box contains the gems, if the rules determine a unique answer.

Fixed layout: blue is left, white is center, black is right.

## Skill Input

Provide all three box texts:

```text
Blue: The gems are in the white box.
White: The gems are not in the black box.
Black: The gems are in the white box.
```

Expected output:

```text
Gems: blue
Reason: Only the blue candidate has at least one all-true box and at least one all-false box.
```

## Supported Agents

This repository uses a conservative Agent Skills-compatible layout:

```text
skills/blue-prince-parlor-solver/SKILL.md
```

The same skill can be installed for:

- Claude Code: `~/.claude/skills/blue-prince-parlor-solver`
- OpenCode: `~/.config/opencode/skills/blue-prince-parlor-solver`
- Pi: `~/.pi/agent/skills/blue-prince-parlor-solver`
- Shared Agent Skills location: `~/.agents/skills/blue-prince-parlor-solver`

OpenCode and Pi also discover `.agents/skills`, so installing there is a useful portable default.

## Non-Nix Install

Install symlinks into all supported global skill locations:

```bash
./scripts/install.sh
```

Copy instead of symlink:

```bash
./scripts/install.sh --copy
```

Install for one target:

```bash
./scripts/install.sh --target claude
./scripts/install.sh --target opencode
./scripts/install.sh --target pi
./scripts/install.sh --target agents
```

This installer uses only POSIX shell and common coreutils. It works on NixOS without using Nix to install the skill.

## Nix Package

Build the package:

```bash
nix build
```

The skill is installed in the package output at:

```text
$out/share/agent-skills/blue-prince-parlor-solver
```

The package also exposes helper commands:

```text
blue-prince-parlor-solver-install
blue-prince-parlor-solver-validate
```

## Home Manager

Use the module from this flake:

```nix
{
  inputs.blue-prince-parlor-solver.url = "path:/path/to/blueprince-parlor-solver";

  outputs = { home-manager, blue-prince-parlor-solver, ... }: {
    homeConfigurations.alice = home-manager.lib.homeManagerConfiguration {
      modules = [
        blue-prince-parlor-solver.homeManagerModules.default
        {
          programs.bluePrinceParlorSolverSkill.enable = true;
          programs.bluePrinceParlorSolverSkill.installFor = [
            "claude"
            "opencode"
            "pi"
            "agents"
          ];
        }
      ];
    };
  };
}
```

## NixOS Module

Use the module from this flake:

```nix
{
  inputs.blue-prince-parlor-solver.url = "path:/path/to/blueprince-parlor-solver";

  outputs = { nixpkgs, blue-prince-parlor-solver, ... }: {
    nixosConfigurations.host = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        blue-prince-parlor-solver.nixosModules.default
        {
          programs.bluePrinceParlorSolverSkill = {
            enable = true;
            users = [ "alice" ];
            installFor = [ "claude" "opencode" "pi" "agents" ];
          };
        }
      ];
    };
  };
}
```

The NixOS module installs the package system-wide and creates per-user symlinks for users listed in `programs.bluePrinceParlorSolverSkill.users`.

## Claude Code Usage

After installing to `~/.claude/skills`, invoke:

```text
/blue-prince-parlor-solver Blue: ... White: ... Black: ...
```

Claude Code can also invoke it automatically when you ask it to solve a Blue Prince Parlor Puzzle.

## OpenCode Usage

After installing to `~/.config/opencode/skills` or `~/.agents/skills`, ask OpenCode to solve the puzzle or load the skill by name when available:

```text
Use the blue-prince-parlor-solver skill.
Blue: ...
White: ...
Black: ...
```

## Pi Usage

After installing to `~/.pi/agent/skills` or `~/.agents/skills`, invoke:

```text
/skill:blue-prince-parlor-solver Blue: ... White: ... Black: ...
```

## Solving Method

The skill tests each possible gem location: blue, white, and black.

For each candidate, it evaluates every statement on every box. A candidate is valid only when at least one box displays only true statements and at least one box displays only false statements. The answer is the unique valid candidate.

If the provided wording permits multiple valid candidates, the skill reports ambiguity. If no candidate is valid, it reports inconsistency and asks for exact wording.

## Validation

Run:

```bash
./scripts/validate-skill.sh
nix flake check
```
