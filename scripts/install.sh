#!/usr/bin/env sh
set -eu

usage() {
  cat <<'EOF'
Usage: scripts/install.sh [--copy] [--target claude|opencode|pi|agents|all]

Installs the blue-prince-parlor-solver skill into global agent skill directories.

Options:
  --copy          Copy the skill instead of creating a symlink.
  --target NAME   Install only for one target. Default: all.
  --help          Show this help.

Environment:
  HOME            Base home directory. Defaults to the current user's home.
  XDG_CONFIG_HOME OpenCode config base. Defaults to $HOME/.config.
EOF
}

mode=symlink
target=all

while [ "$#" -gt 0 ]; do
  case "$1" in
    --copy)
      mode=copy
      ;;
    --target)
      if [ "$#" -lt 2 ]; then
        echo "error: --target requires a value" >&2
        exit 2
      fi
      target=$2
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "error: unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
  shift
done

case "$target" in
  claude|opencode|pi|agents|all) ;;
  *)
    echo "error: invalid target: $target" >&2
    exit 2
    ;;
esac

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo_dir=$(CDPATH= cd -- "$script_dir/.." && pwd)
skill_name=blue-prince-parlor-solver
source_dir=$repo_dir/skills/$skill_name

if [ ! -f "$source_dir/SKILL.md" ]; then
  echo "error: missing skill source at $source_dir" >&2
  exit 1
fi

home_dir=${HOME:-}
if [ -z "$home_dir" ]; then
  echo "error: HOME is not set" >&2
  exit 1
fi

xdg_config_home=${XDG_CONFIG_HOME:-$home_dir/.config}

install_one() {
  parent=$1
  dest=$parent/$skill_name

  mkdir -p "$parent"
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    rm -rf "$dest"
  fi

  if [ "$mode" = copy ]; then
    cp -R "$source_dir" "$dest"
    echo "copied $dest"
  else
    ln -s "$source_dir" "$dest"
    echo "linked $dest -> $source_dir"
  fi
}

install_target() {
  case "$1" in
    claude)
      install_one "$home_dir/.claude/skills"
      ;;
    opencode)
      install_one "$xdg_config_home/opencode/skills"
      ;;
    pi)
      install_one "$home_dir/.pi/agent/skills"
      ;;
    agents)
      install_one "$home_dir/.agents/skills"
      ;;
  esac
}

if [ "$target" = all ]; then
  install_target claude
  install_target opencode
  install_target pi
  install_target agents
else
  install_target "$target"
fi
