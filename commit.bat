@echo off
setlocal
REM TheRidgwells .github - Git commit + tag script (Windows)
REM Commits whatever's staged/unstaged and tags it with the version currently in VERSION.md,
REM read dynamically so this script never goes stale the way a hardcoded version does.
REM
REM Versioning has two stages: Semantic Versioning on 0.x.y before the first stable release,
REM then Date Versioning (https://datevers.ing, YY.MM.DD or YY.MM.DD-N, UTC) from the first stable
REM release on. There is never a 1.0.0, and no going back to SemVer once a Date Version is tagged.

set "DIR=%~dp0"
cd /d "%DIR%"
set /p VERSION=<"%DIR%VERSION.md"

powershell -NoProfile -Command ^
  "$v = '%VERSION%'.Trim();" ^
  "$dv = '^\d{2}\.(0[1-9]|1[0-2])\.(0[1-9]|[12]\d|3[01])(-[1-9]\d*)?$';" ^
  "if ($v -match '^0\.(0|[1-9]\d*)\.(0|[1-9]\d*)$') {" ^
  "  $tags = git tag -l 'v*' | ForEach-Object { $_.Substring(1) };" ^
  "  if ($tags | Where-Object { $_ -match $dv }) { exit 4 }; exit 0 }" ^
  "if ($v -notmatch $dv) { exit 1 };" ^
  "$d = $v.Split('-')[0]; $p = [DateTime]::MinValue;" ^
  "if (-not [DateTime]::TryParseExact($d, 'yy.MM.dd', [Globalization.CultureInfo]::InvariantCulture, 'None', [ref]$p)) { exit 1 };" ^
  "$t = [DateTime]::UtcNow.ToString('yy.MM.dd'); if ($d -gt $t) { exit 2 }; if ($d -lt $t) { exit 3 }; exit 0"
if errorlevel 4 (
    echo VERSION.md holds %VERSION%, but this project has already moved to Date Versioning. Use today's date ^(YY.MM.DD^).
    exit /b 1
) else if errorlevel 3 (
    echo Warning: VERSION.md is dated before today ^(UTC^). Releasing today? Use today's date.
) else if errorlevel 2 (
    echo VERSION.md holds %VERSION%, which is dated in the future ^(UTC^). Date Versions can't be.
    exit /b 1
) else if errorlevel 1 (
    echo VERSION.md holds %VERSION%, which is neither a pre-stable SemVer version ^(0.x.y^) nor a real Date Version ^(YY.MM.DD or YY.MM.DD-N^). There is no 1.0.0.
    exit /b 1
)

git add -A
git diff --cached --quiet
if errorlevel 1 (
    git commit -m "Release v%VERSION%" -m "See CHANGELOG.md for details."
) else (
    echo Nothing to commit - tagging the current HEAD as v%VERSION%.
)

git rev-parse "v%VERSION%" >nul 2>&1
if errorlevel 1 (
    git tag -a "v%VERSION%" -m "TheRidgwells .github v%VERSION%"
    echo Tagged v%VERSION%.
) else (
    echo Tag v%VERSION% already exists - skipping.
)

echo Push with: git push origin test, then git push origin v%VERSION%, then open a pull request from test into main.
