# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Keystone Components is a Rails gem providing reusable UI components built on `view_component`. It provides UI primitives that avoid ERB noise, prevent UI drift, and enable safe mass updates.

## Commands

```bash
bundle install              # Install dependencies
bundle exec rspec           # Run all tests
bundle exec rspec spec/keystone/ui/button_component_spec.rb  # Run a single test file
```

No build step or linter is configured.

## Architecture

This is a Rails engine gem structured around ViewComponent. The three-layer architecture is:

1. **Components** (`app/components/keystone/ui/`) — Ruby classes inheriting `ViewComponent::Base` with explicit keyword arguments, paired with `.html.erb` templates. All UI logic lives here.
2. **Helpers** (`app/helpers/keystone_ui_helper.rb`) — Thin render wrappers that delegate to components. Helpers contain no logic or conditionals. Consuming apps use helpers, not component classes directly.
3. **Themes** (`app/assets/stylesheets/keystone/themes/`) — CSS-only theming via custom properties. Components reference semantic classes (`bg-card`, `text-primary`); themes swap variable definitions without changing markup.

The engine (`lib/keystone_components/engine.rb`) registers theme stylesheets for the Rails asset pipeline.

## Design Principles

- All UI lives in ViewComponents (no partials).
- Components are Ruby objects with explicit keyword arguments.
- Helpers are thin render wrappers with no logic or conditionals.
- Styling is semantic and token-driven via CSS variables.
- Themes are CSS-only and switch by swapping variable definitions.

## Testing

Tests use RSpec. The spec helper stubs `ViewComponent::Base` so tests run without a full Rails environment. Tests validate component logic (class composition, tag options, normalization) rather than rendered HTML.

## Key Conventions

- Ruby >= 3.0.0 required.
- Components live under the `Keystone::Ui` namespace.
- The DataTableComponent uses Tailwind CSS utility classes with predefined position-based class constants (first/middle/last cell styling). It accepts `items` (AR objects or hashes) and `columns` (simple `{ key: "Label" }` hashes or `Keystone::Ui::Column` objects), resolving cell values automatically. `Column` objects support per-column options like `mobile_hidden: true` which appends `hidden sm:table-cell` classes. A block-based API registers links via `table.link(:column_key) { |item| url }` and actions via `table.actions { |item| ... }`. When an actions column is present, position classes shift so the actions column gets LAST styling.
- ButtonComponent conditionally renders `<a>` or `<button>` based on whether `href` is provided.
