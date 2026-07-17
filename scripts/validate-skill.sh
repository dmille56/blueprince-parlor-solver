#!/usr/bin/env sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo_dir=$(CDPATH= cd -- "$script_dir/.." && pwd)
skill_name=blue-prince-parlor-solver
skill_dir=$repo_dir/skills/$skill_name
skill_file=$skill_dir/SKILL.md

fail() {
  echo "error: $1" >&2
  exit 1
}

[ -d "$skill_dir" ] || fail "missing skill directory: $skill_dir"
[ -f "$skill_file" ] || fail "missing SKILL.md"

first_line=$(sed -n '1p' "$skill_file")
[ "$first_line" = "---" ] || fail "SKILL.md must start with YAML frontmatter"

name=$(sed -n 's/^name: *//p' "$skill_file" | sed -n '1p')
description=$(sed -n 's/^description: *//p' "$skill_file" | sed -n '1p')

[ "$name" = "$skill_name" ] || fail "name must be $skill_name"
[ -n "$description" ] || fail "description is required"

case "$name" in
  ''|*[!abcdefghijklmnopqrstuvwxyz0123456789-]*|-*|*-) fail "invalid skill name: $name" ;;
  *--*) fail "skill name must not contain consecutive hyphens" ;;
esac

description_len=$(printf '%s' "$description" | wc -c | tr -d ' ')
[ "$description_len" -le 1024 ] || fail "description exceeds 1024 characters"

grep -q 'references/parlor-rules.md' "$skill_file" || fail "SKILL.md must reference parlor rules"
grep -q 'examples.md' "$skill_file" || fail "SKILL.md must reference examples"

[ -f "$skill_dir/references/parlor-rules.md" ] || fail "missing references/parlor-rules.md"
[ -f "$skill_dir/examples.md" ] || fail "missing examples.md"

echo "ok: $skill_name"
