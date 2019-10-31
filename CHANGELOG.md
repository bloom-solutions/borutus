# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.4] - 2019-10-31
### Removed
- Remove `AddBorutusAmountCounterCache` reset counter code

## [0.2.3] - 2019-10-25
### Fixed
- Fix `AddBorutusAmountCounterCache` migration

### Added
- Add correct migration for `Borutus::Account.amounts_count`

## [0.2.2] - 2019-10-25
### Added
- Add `Borutus::Account.with_amounts` scope that fetches accounts with amount entries

### Changed
- Change usage of `BigDecimal.new` to `BigDecimal()`
- Change `FactoryGirl` to `FactoryBot`

## [0.2.1] - 2019-01-04
### Added
- Add `#change_amount` column for `account.entries.with_running_balance` association proxy collection

## [0.2.0] - 2019-01-04
### Added
- Add `account.entries.with_running_balance` association proxy method
- Add `pry-byebug` in `Gemfile` for local development

## [0.1.0]
### Fixed
- Fix loading of jquery-ui files (Fixes https://github.com/mbulat/borutus/issues/58)

### Added
- Add `Account#amounts` and `Account#entries` to get all amounts and entries, respectively

### Changed
- How migrations are done, which may be a breaking change from older versions of Borutus. When upgrading to this version, run `rake borutus:install:migrations`, and ensure that the files that are generated are of migrations you only need. It should not generate new versions if you've installed the latest version before this.
