#!/usr/bin/env bash
# Checks VERSION.md. Versioning has two stages: pre-stable Semantic Versioning on 0.x.y
# (https://semver.org), then, from the first stable release on, Date Versioning
# (https://datevers.ing): the UTC release date as YY.MM.DD, plus -1, -2... for later releases
# the same day. There is never a 1.0.0, and no going back to 0.x.y once a Date Version is tagged.
# Run with: bash tests/version.sh
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PASS=0
FAIL=0
check() { # check "description" command...
    local name="$1"; shift
    if "$@"; then PASS=$((PASS + 1)); echo "ok   - $name"; else FAIL=$((FAIL + 1)); echo "FAIL - $name"; fi
}

SEMVER='^0\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$'
# The spec's own pattern (2000-2099 form); calendar validity is checked separately.
DATEVER='^[0-9]{2}\.(0[1-9]|1[0-2])\.(0[1-9]|[12][0-9]|3[01])(-[1-9][0-9]*)?$'
VERSION="$(tr -d '[:space:]' < "$ROOT/VERSION.md")"

is_semver()    { [[ "$VERSION" =~ $SEMVER ]]; }
is_datever()   { [[ "$VERSION" =~ $DATEVER ]]; }
is_version()   { is_semver || is_datever; }
is_real_date() { # an impossible date (26.02.30) fails or comes back different
    is_semver && return 0
    local d="${VERSION%%-*}" yy mm dd; IFS=. read -r yy mm dd <<< "$d"
    [ "$(date -u -d "20$yy-$mm-$dd" +%y.%m.%d 2>/dev/null)" = "$d" ]
}
not_future()   { is_semver || [[ ! "${VERSION%%-*}" > "$(date -u +%y.%m.%d)" ]]; }
no_semver_after_datever() { # once a Date Version is tagged, VERSION.md can't go back to 0.x.y
    is_semver || return 0
    ! git -C "$ROOT" tag -l 'v*' 2>/dev/null | sed 's/^v//' | grep -Eq "$DATEVER"
}
changelog_leads() {
    [ "$(grep -m1 -oE '^## v[^[:space:]]+' "$ROOT/CHANGELOG.md" | sed 's/^## v//')" = "$VERSION" ]
}

check "VERSION.md ($VERSION) is 0.x.y or a Date Version (YY.MM.DD or YY.MM.DD-N)" is_version
check "VERSION.md ($VERSION) is a real calendar date, if it's a Date Version" is_real_date
check "VERSION.md ($VERSION) isn't dated in the future (UTC)" not_future
check "VERSION.md ($VERSION) doesn't go back to 0.x.y after a Date Version tag" no_semver_after_datever
check "the newest '## v...' heading in CHANGELOG.md is VERSION.md" changelog_leads

echo "$PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
