# Contributing

This is The Ridgwell Family's organisation profile, so changes come from the family. Suggestions are welcome as
issues.

## Branches and going live

- **`main` is what's live.** Nothing is pushed to it directly: it only changes when a pull request from `staging` is merged, with a merge commit so the release tags stay in its history. It's what GitHub shows on the organisation's profile.
- **`staging` is the last check before live.** It only changes when a pull request from `test` is merged. GitHub only shows `main`.
- **Work happens on `test`**, or on a branch off it that's merged back into it. Releases are made there too: `commit.sh` / `commit.bat` refuse to run on `staging` or `main`.
- **Going live:** push `test` with its tag (`git push origin test --tags`), open a pull request into staging (`gh pr create --base staging --head test`), check staging once it's merged, then open one from staging into main (`gh pr create --base main --head staging`). Leo merges both.
- Before opening a pull request, merge the branch it goes into back into yours if it has moved.

## Releasing

1. Add a `## vX` section at the top of `CHANGELOG.md`, with `### Added`, `### Changed`, `### Fixed`, `### Removed`,
   `### Security` and `### Deprecated` sections in that order (only the ones you need).
2. Bump `VERSION.md` (the bare version, no `v`).
3. Update the README if anything it describes changed.
4. Run `bash tests/version.sh`.
5. Run `./commit.sh` (or `commit.bat`): it checks the version, commits and tags `vX`, and never pushes.
6. `git push origin test --tags`, then take it through staging to main with pull requests (see above).

Versions are Date Versions (`YY.MM.DD`, the UTC release date, never in the future, with `-1`, `-2`… for later
releases the same day). The project has been stable since v26.11.07, its first Date Version, and never goes back to
`0.x.y`; the commit scripts and `tests/version.sh` enforce both.
