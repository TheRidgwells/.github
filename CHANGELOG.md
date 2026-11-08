# Changelog

All notable changes to The Ridgwell Family's GitHub organisation profile are documented here. The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), with sections always in the order Added, Changed, Fixed,
Removed, Security, Deprecated. It uses [Date Versioning](https://datevers.ing) (`YY.MM.DD`, the UTC release date, with `-1`, `-2`… for later
releases the same day) since v26.11.07, its first stable release; v0.1.0 was pre-stable, on
[Semantic Versioning](https://semver.org) `0.x.y`.

## v26.11.08

### Changed

- **Ridgwell Status is "checked regularly",** not "every 5 minutes": GitHub runs its 5-minute schedule on a
  best-effort basis, often less often, and the status page now shows the real rhythm.

## v26.11.07

### Changed

- **The first stable release.** The profile moves from pre-stable [Semantic Versioning](https://semver.org)
  (`0.x.y`) to [Date Versioning](https://datevers.ing): from now on each release is its UTC release date as
  `YY.MM.DD`, with `-1`, `-2`… for later releases the same day. There is no 1.0.0; this is v26.11.07, and it never goes
  back to `0.x.y` (the commit scripts refuse). Nothing else changes but the version.

## v0.1.0

### Added

- **The organisation profile** (`profile/README.md`): the family logo (for light and dark themes), every family site
  with what it is, the private repositories by name, and links to Ridgwell Status and the Projects page.
- README, CONTRIBUTING, this changelog, `VERSION.md`, the commit scripts and `tests/version.sh`.
