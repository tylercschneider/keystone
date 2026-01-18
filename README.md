# Keystone Components

Keystone Components is a reusable UI component system for Rails applications built on the
`view_component` gem. It provides stable, authoritative UI primitives that avoid ERB noise,
prevent UI drift, and enable safe mass updates.

## Principles

- All UI lives in ViewComponents (no partials).
- Components are Ruby objects with explicit keyword arguments.
- Helpers are thin render wrappers with no logic or conditionals.
- Styling is semantic and token-driven via CSS variables.
- Themes are CSS-only and switch by swapping variable definitions.

## Installation

Add the gem to your application:

```ruby
gem "keystone_components"
```

Include one of the theme stylesheets (base or dark) in your asset pipeline:

```scss
@import "keystone/themes/base";
```

## Helper API (primary surface)

Use the helpers in ERB. Consuming apps should not instantiate components directly.

```erb
<%= ui_card(
  title: "Revenue",
  summary: "$42,300 this month",
  link: reports_path
) %>

<%= ui_button(
  label: "Create invoice",
  href: new_invoice_path,
  variant: :primary
) %>
```

## Available Components

### `ui_card`

Renders a card layout with a title, summary, and a single call-to-action link.

**Required props**

- `title:` (String)
- `summary:` (String)
- `link:` (String or URL)

**Optional props**

- `cta:` (String, default `"Read more"`)

### `ui_button`

Renders a deterministic button or link. If `href` is present, an `<a>` tag is rendered.
Otherwise, a `<button>` tag is rendered with `type="button"`.

**Required props**

- `label:` (String)

**Optional props**

- `href:` (String or URL)
- `variant:` (`:primary | :secondary | :danger`, default `:primary`)
- `size:` (`:sm | :md | :lg`, default `:md`)

## Theming

Components reference semantic classes (e.g., `bg-card`, `text-primary`) and rely on CSS
variables for actual colors. Themes override variables only; component markup never changes.

Included themes:

- `keystone/themes/base.css` — light theme with neutral defaults.
- `keystone/themes/dark.css` — dark theme overrides variables only.
