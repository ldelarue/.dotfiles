#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
lockfile="$script_dir/../skills/skills.lock.json"

if ! command -v gh >/dev/null 2>&1; then
  printf '%s\n' 'GitHub CLI (gh) is required.' >&2
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  printf '%s\n' 'jq is required.' >&2
  exit 1
fi

jq -c '.[]' "$lockfile" | while IFS= read -r entry; do
  repo=$(printf '%s' "$entry" | jq -r '.sourceURL' | sed 's#https://github.com/##')
  name=$(printf '%s' "$entry" | jq -r '.skillName')
  version=$(printf '%s' "$entry" | jq -r '.version')
  scope=$(printf '%s' "$entry" | jq -r '.scope')
  agent=$(printf '%s' "$entry" | jq -r '.agentHosts[0]')
  printf 'Installing %s from %s@%s (%s, %s)\n' "$name" "$repo" "$version" "$scope" "$agent"
  gh skill install "$repo" "$name@$version" --agent "$agent" --scope "$scope" -f
done
