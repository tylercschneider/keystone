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

<%= ui_data_table(
  items: @products,
  columns: [
    { name: "Name", link: ->(item) { product_path(item) } },
    { quantity: "Quantity" },
    { price: "Price" }
  ],
  empty_message: "No products found."
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

### `ui_data_table`

Renders a responsive data table. Accepts a collection of items (ActiveRecord objects, Structs, or hashes) and column definitions that map lookup keys to header labels.

**Required props**

- `items:` (Array) — collection of AR objects, Structs, or hashes
- `columns:` (Array of single-key Hashes) — each hash maps a lookup key to a header label, e.g. `{ name: "Name" }`

**Optional props**

- `empty_message:` (String) — message displayed when `items` is empty

**Linkable cells**

Add a `:link` lambda to any column definition to wrap that cell's value in an `<a>` tag. The lambda receives the current item and must return a URL string.

```erb
<%= ui_data_table(
  items: @products,
  columns: [
    { name: "Name", link: ->(item) { product_path(item) } },
    { quantity: "Quantity" },
    { price: "Price" }
  ]
) %>
```

**Actions column**

Pass a block to add a trailing "Actions" column. The block receives the component instance; call `actions` on it with a sub-block that receives each item.

```erb
<%= ui_data_table(
  items: @products,
  columns: [
    { name: "Name", link: ->(item) { product_path(item) } },
    { status: "Status" }
  ]
) do |table| %>
  <% table.actions do |item| %>
    <%= link_to "Edit", edit_product_path(item) %>
    <%= link_to "Delete", product_path(item), data: { turbo_method: :delete } %>
  <% end %>
<% end %>
```

When an actions column is present, position-based styling classes shift automatically — the last data column receives middle styling and the actions column receives last styling.

## Theming

Components reference semantic classes (e.g., `bg-card`, `text-primary`) and rely on CSS
variables for actual colors. Themes override variables only; component markup never changes.

Included themes:

- `keystone/themes/base.css` — light theme with neutral defaults.
- `keystone/themes/dark.css` — dark theme overrides variables only.
