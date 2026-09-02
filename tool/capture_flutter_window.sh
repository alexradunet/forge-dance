#!/usr/bin/env bash
# Capture the visible Forge Dance window on Omarchy/Hyprland for visual review.
set -euo pipefail
cd "$(dirname "$0")/.."

pattern="${1:-Forge Dance|forge_dance|dance\.forge\.app}"
output="${2:-build/live/flutter-window.png}"

for command_name in hyprctl jq grim; do
  if ! command -v "$command_name" >/dev/null 2>&1; then
    echo "Required Omarchy capture command is unavailable: $command_name" >&2
    exit 1
  fi
done

client="$({ hyprctl clients -j || true; } | jq -c --arg pattern "$pattern" '
  [
    .[]
    | select(.mapped == true and .hidden == false)
    | select(
        ([.title, .class, .initialTitle, .initialClass] | map(. // "") | join("\n"))
        | test($pattern; "i")
      )
  ]
  | sort_by(.focusHistoryID // 999999)
  | .[0] // empty
')"

if [[ -z "$client" ]]; then
  echo "No visible Hyprland window matched: $pattern" >&2
  echo "Visible windows:" >&2
  hyprctl clients -j | jq -r '.[] | select(.mapped == true and .hidden == false) | "  \(.class): \(.title)"' >&2
  exit 1
fi

stable_id="$(jq -r '.stableId // empty' <<<"$client")"
x="$(jq -r '.at[0]' <<<"$client")"
y="$(jq -r '.at[1]' <<<"$client")"
width="$(jq -r '.size[0]' <<<"$client")"
height="$(jq -r '.size[1]' <<<"$client")"

mkdir -p "$(dirname "$output")"
if [[ -n "$stable_id" ]]; then
  # Newer Hyprland versions expose the foreign-toplevel identifier, allowing
  # grim to capture the app even when another window overlaps it.
  grim -T "$stable_id" "$output"
else
  grim -g "$x,$y ${width}x${height}" "$output"
fi
realpath "$output"
