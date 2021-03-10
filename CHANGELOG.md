# Change Log

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased][unreleased]

### Added

- Support for Email Overrides. Use Rails settings to override Courier template.
  - You will need to set the subject to `CourierRails::USE_COURIER_SUBJECT` or Courier template subject will be overridden with default provided by Rails.
- Added constant for DEFAULT_COURIER_BODY: `CourierRails::DEFAULT_COURIER_BODY`.

## [v0.1.5] - 2021-01-30

Failed to bump version on v0.1.4 release.

## [v0.1.4] - 2021-01-30

## Added

- Tests and GitHub Action
- Using [StandardRB](https://github.com/testdouble/standard) for linting
- Use email as Courier recipient id if `recipient` isn't present in `courier_data`

## Changed

- Require Rails version 6+ instead of 6.1+

## v0.1.3 - 2020-12-17

Initial release.

[unreleased]: https://github.com/trycourier/courier-ruby-rails/compare/v0.1.5...HEAD
[v0.1.5]: https://github.com/trycourier/courier-ruby-rails/compare/v0.1.4...v0.1.5
[v0.1.4]: https://github.com/trycourier/courier-ruby-rails/compare/v0.1.3...v0.1.4
