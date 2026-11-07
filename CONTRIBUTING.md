# Contributing

This is The Ridgwell Family's organisation profile, so changes come from the family. Suggestions are welcome as
issues.

## Branches and pull requests

- `main` is what GitHub shows. It only changes when a pull request from `test` is merged, with a merge commit so the
  release tags stay in `main`'s history.
- `test` is the working branch.

## Releasing

1. Add a `## vX` section at the top of `CHANGELOG.md`, with `### Added`, `### Changed`, `### Fixed`, `### Removed`,
   `### Security` and `### Deprecated` sections in that order (only the ones you need).
2. Bump `VERSION.md` (the bare version, no `v`).
3. Update the README if anything it describes changed.
4. Run `bash tests/version.sh`.
5. Run `./commit.sh` (or `commit.bat`): it checks the version, commits and tags `vX`, and never pushes.
6. `git push origin test`, then `git push origin vX`, and open a pull request from `test` into `main`.

Versions are Date Versions (`YY.MM.DD`, the UTC release date, never in the future, with `-1`, `-2`… for later
releases the same day). The project has been stable since v26.11.07, its first Date Version, and never goes back to
`0.x.y`; the commit scripts and `tests/version.sh` enforce both.
