#!/bin/bash
# TheRidgwells .github - Git commit + tag script
# Commits whatever's staged/unstaged and tags it with the version currently in VERSION.md,
# read dynamically so this script never goes stale the way a hardcoded version does.
#
# Versioning has two stages:
#   - before the first stable release: Semantic Versioning on 0.x.y (https://semver.org)
#   - the first stable release and everything after it: Date Versioning (https://datevers.ing),
#     the UTC release date as YY.MM.DD, plus -1, -2... for later releases the same day.
# There is never a 1.0.0, and once a Date Version has been tagged there's no going back to SemVer.
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"
VERSION="$(tr -d '[:space:]' < "$DIR/VERSION.md")"

SEMVER='^0\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$'
DATEVER='^[0-9]{2}\.(0[1-9]|1[0-2])\.(0[1-9]|[12][0-9]|3[01])(-[1-9][0-9]*)?$'

if [[ "$VERSION" =~ $SEMVER ]]; then
    if git tag -l 'v*' | sed 's/^v//' | grep -Eq "$DATEVER"; then
        echo "VERSION.md holds '$VERSION', but this project has already moved to Date Versioning. Use today's date (YY.MM.DD)." >&2
        exit 1
    fi
elif [[ "$VERSION" =~ $DATEVER ]]; then
    DATE="${VERSION%%-*}"
    IFS=. read -r YY MM DD <<< "$DATE"
    if [ "$(date -u -d "20$YY-$MM-$DD" +%y.%m.%d 2>/dev/null)" != "$DATE" ]; then
        echo "VERSION.md holds '$VERSION', which isn't a real date." >&2
        exit 1
    fi
    TODAY="$(date -u +%y.%m.%d)"
    if [[ "$DATE" > "$TODAY" ]]; then
        echo "VERSION.md is dated $DATE, after today ($TODAY UTC). Date Versions can't be in the future." >&2
        exit 1
    elif [[ "$DATE" < "$TODAY" ]]; then
        echo "Warning: VERSION.md is dated $DATE, but today is $TODAY (UTC). Releasing today? Use $TODAY." >&2
    fi
else
    echo "VERSION.md holds '$VERSION', which is neither a pre-stable SemVer version (0.x.y) nor a Date Version (YY.MM.DD or YY.MM.DD-N, see https://datevers.ing). There is no 1.0.0: the first stable release is dated." >&2
    exit 1
fi

git add -A
if ! git diff --cached --quiet; then
    git commit -m "$(cat <<MSG
Release v${VERSION}

See CHANGELOG.md for details.
MSG
)"
else
    echo "Nothing to commit - tagging the current HEAD as v${VERSION}."
fi

if git rev-parse "v${VERSION}" >/dev/null 2>&1; then
    echo "Tag v${VERSION} already exists - skipping."
else
    git tag -a "v${VERSION}" -m "TheRidgwells .github v${VERSION}"
    echo "Tagged v${VERSION}."
fi

echo "Push with: git push origin test, then git push origin v${VERSION}, then open a pull request from test into main."
