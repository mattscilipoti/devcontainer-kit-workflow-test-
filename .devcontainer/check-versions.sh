#!/usr/bin/env bash
# Compares the versions pinned in .devcontainer/versions.json with the newest
# supported releases (endoflife.date, RubyGems). Exits 1 and prints what is
# behind. Runs in CI weekly (.github/workflows/scheduled-checks.yml) and by hand.
# Needs curl and jq.
set -euo pipefail

versions_file="$(dirname "$0")/versions.json"
behind=0

newest_supported() { # product -> "cycle latest" of the newest supported release
  curl -fsS "https://endoflife.date/api/$1.json" |
    jq -r --arg today "$(date -u +%F)" \
      '[.[] | select(.eol == false or (.eol | type == "string" and . >= $today))][0] | "\(.cycle) \(.latest)"'
}

compare() { # label pinned newest
  if [ "$2" != "$3" ]; then
    printf 'BEHIND  %-8s pinned %s, newest supported %s\n' "$1" "$2" "$3"
    behind=1
  else
    printf 'ok      %-8s %s\n' "$1" "$2"
  fi
}

pinned() { jq -r --arg k "$1" '.[$k] // empty' "$versions_file"; }

[ -z "$(pinned ruby)" ] || compare ruby "$(pinned ruby)" "$(newest_supported ruby | cut -d' ' -f2)"
[ -z "$(pinned go)" ] || compare go "$(pinned go)" "$(newest_supported go | cut -d' ' -f2)"
[ -z "$(pinned rails)" ] || compare rails "$(pinned rails)" \
  "$(curl -fsS https://rubygems.org/api/v1/versions/rails/latest.json | jq -r .version)"
if [ -n "$(pinned node)" ]; then
  newest_lts="$(curl -fsS https://endoflife.date/api/nodejs.json | jq -r --arg today "$(date -u +%F)" \
    '[.[] | select((.lts | type == "string") and .lts <= $today and (.eol == false or .eol >= $today))][0].cycle')"
  compare "node(LTS)" "$(pinned node)" "$newest_lts"
fi

exit "$behind"
