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

While pre-stable, versions are `0.x.y`. The first stable release is a Date Version (`YY.MM.DD`, UTC, never in the
future) instead of `1.0.0`, and every release from then on is too; the commit scripts and `tests/version.sh` enforce
both.
