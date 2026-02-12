# Changelog

All notable changes to this project will be documented in this file.

## [0.4.1] - 2026-02-11

### Fixed
- Resolved bundle dependency issue requiring force-resolve on version bump

## [0.4.0] - 2026-02-11

### Added
- **PageHeaderComponent** — page title area with optional action slots
- **AlertComponent** — flash messages and inline notifications with type variants and optional dismiss
- Safelist auto-generation from component constants

### Fixed
- Install generator auto-injects CSS import without prompting
- Railtie initializer injects `@source` path at boot time (replaces inline safelist approach)
- Generator cleans up legacy import and safelist lines on upgrade

## [0.3.0] - 2026-02-10

### Added
- **InputComponent** — standalone text/number/email input with base Tailwind classes
- **TextareaComponent** — multi-line text input
- **FormFieldComponent** — wraps label, input, hint, and error in consistent layout

## [0.2.0] - 2026-02-09

### Added
- **CardLinkComponent** — clickable card wrapping content in an `<a>` tag
- **PageComponent** — page wrapper with max-width and responsive padding
- **SectionComponent** — content grouping with optional header and spacing
- **GridComponent** — CSS grid with responsive columns and gap sizes (static `COL_CLASSES` hash)
- **PanelComponent** — bordered container with padding, radius, and shadow options
- Split gap support (`gap_x`/`gap_y`) for GridComponent
- `rake keystone:claude` task for generating API reference in consuming apps
- Install generator for host app setup
- GitHub Actions CI workflow

### Fixed
- DataTable styling: consistent rounding, padding, and borders
- Card and Button components converted from custom CSS to Tailwind utilities

## [0.1.0] - 2026-02-08

### Added
- **CardComponent** — card layout with title, summary, and CTA
- **ButtonComponent** — button/link with variants (primary/secondary/danger) and sizes
- **DataTableComponent** — responsive data table with block-based link and actions API
  - Column objects with `mobile_hidden` option
  - Position-based cell styling (first/middle/last)
