# Keystone Components

Keystone Components is a reusable UI component system for Rails applications built on the
`view_component` gem. It provides stable, authoritative UI primitives that avoid ERB noise,
prevent UI drift, and enable safe mass updates.

## Principles

- All UI lives in ViewComponents (no partials).
- Components are Ruby objects with explicit keyword arguments.
- Helpers are thin render wrappers with no logic or conditionals.
- Styling uses Tailwind CSS utility classes applied directly in components.

## Installation

### Prerequisites

- Rails 7+
- **tailwindcss-rails v4+** — components use Tailwind CSS utility classes and ship a
  `@source` directive that tells Tailwind where to scan for classes.

### Steps

1. Add the gem to your Gemfile:

```ruby
gem "keystone_components"
```

2. Run `bundle install`.

3. Run the install generator for guided setup:

```bash
rails generate keystone:install
```

The generator checks for `tailwindcss-rails`, and optionally injects the
required `@import` into your `app/assets/tailwind/application.css`:

```css
@import "../builds/tailwind/keystone_components_engine";
```

If you prefer manual setup, add that import line yourself. You may also need
to run `rails tailwindcss:engines` to generate the build entry point (this
happens automatically on `tailwindcss:build` and `tailwindcss:watch`).

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
    { name: "Name" },
    { quantity: "Quantity" },
    { price: "Price" }
  ],
  empty_message: "No products found."
) do |table| %>
  <% table.link(:name) { |item| product_path(item) } %>
<% end %>
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
- `edge_to_edge:` (Boolean, default `false`) — when `true`, removes horizontal border-radius and side borders on mobile, restoring them at the `sm` breakpoint. Useful for cards that span the full viewport width on small screens.

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
- `columns:` (Array of Hashes or `Column` objects) — each hash maps a lookup key to a header label, e.g. `{ name: "Name" }`. Use `Keystone::Ui::Column` for per-column options.

**Optional props**

- `empty_message:` (String) — message displayed when `items` is empty

**Mobile-hidden columns**

Use `Keystone::Ui::Column` objects to hide columns on mobile. Columns with `mobile_hidden: true` receive `hidden sm:table-cell` classes, hiding them on small screens and showing them from the `sm` breakpoint up. Columns are visible on mobile by default.

```erb
<%= ui_data_table(
  items: @products,
  columns: [
    Keystone::Ui::Column.new(:name, "Name"),
    Keystone::Ui::Column.new(:quantity, "Quantity", mobile_hidden: true),
    Keystone::Ui::Column.new(:price, "Price")
  ]
) %>
```

**Linkable cells**

Register links via `table.link(:column_key)` in the block. The block receives the current item and must return a URL string. The cell's value is wrapped in an `<a>` tag.

```erb
<%= ui_data_table(
  items: @products,
  columns: [
    { name: "Name" },
    { quantity: "Quantity" },
    { price: "Price" }
  ]
) do |table| %>
  <% table.link(:name) { |item| product_path(item) } %>
<% end %>
```

**Actions column**

Pass a block to add a trailing "Actions" column. The block receives the component instance; call `actions` on it with a sub-block that receives each item.

```erb
<%= ui_data_table(
  items: @products,
  columns: [
    { name: "Name" },
    { status: "Status" }
  ]
) do |table| %>
  <% table.link(:name) { |item| product_path(item) } %>
  <% table.actions do |item| %>
    <%= link_to "Edit", edit_product_path(item) %>
    <%= link_to "Delete", product_path(item), data: { turbo_method: :delete } %>
  <% end %>
<% end %>
```

When an actions column is present, position-based styling classes shift automatically — the last data column receives middle styling and the actions column receives last styling.

### `ui_page`

Wraps page content with consistent max-width and horizontal padding.

**Optional props**

- `max_width:` (`:sm | :md | :lg | :xl | :full`, default `:full`) — constrains content width. Values map to `max-w-2xl`, `max-w-4xl`, `max-w-6xl`, `max-w-7xl`, or no constraint.
- `padding:` (`:standard | :none`, default `:standard`) — adds responsive horizontal padding (`px-4 sm:px-6 lg:px-8`).

```erb
<%= ui_page(max_width: :lg) do %>
  <!-- page content -->
<% end %>
```

### `ui_section`

Groups related content with an optional header (title, subtitle, action) and vertical spacing.

**Optional props**

- `title:` (String) — section heading
- `subtitle:` (String) — secondary text below the title
- `action:` — slot for a trailing action (e.g. a button)
- `spacing:` (`:sm | :md | :lg`, default `:md`) — top margin between sections

```erb
<%= ui_section(title: "Products", subtitle: "All active items", spacing: :lg) do %>
  <!-- section content -->
<% end %>
```

### `ui_grid`

Renders a CSS grid with responsive column counts and configurable gap sizes.

**Optional props**

- `cols:` (Hash, default `{ default: 1 }`) — maps breakpoints to column counts (1-12). Keys: `:default`, `:sm`, `:md`, `:lg`.
- `gap:` (`:sm | :md | :lg | :xl`, default `:md`) — uniform gap size
- `gap_x:` (Symbol) — horizontal gap (overrides `gap:`)
- `gap_y:` (Symbol) — vertical gap (overrides `gap:`)

```erb
<%= ui_grid(cols: { default: 1, sm: 2, lg: 4 }, gap: :lg) do %>
  <!-- grid items -->
<% end %>
```

### `ui_panel`

Renders a bordered, rounded container with padding and optional shadow.

**Optional props**

- `padding:` (`:sm | :md | :lg`, default `:md`)
- `radius:` (`:md | :lg | :xl`, default `:lg`)
- `shadow:` (Boolean, default `true`)

```erb
<%= ui_panel(padding: :lg) do %>
  <!-- panel content -->
<% end %>
```

### `ui_card_link`

Renders a clickable card that wraps its content in an `<a>` tag with hover styling.

**Required props**

- `href:` (String or URL)

**Optional props**

- `padding:` (`:sm | :md | :lg`, default `:md`)
- `shadow:` (Boolean, default `true`)

```erb
<%= ui_card_link(href: product_path(@product)) do %>
  <h3>Product name</h3>
  <p>Product description</p>
<% end %>
```

### `ui_form_field`

Wraps a label, input, hint, and error message in a consistent layout. Infers label text from the attribute name when not explicitly provided.

**Required props**

- `attribute:` (Symbol) — the form attribute name

**Optional props**

- `label:` (String) — explicit label text (inferred from `attribute:` if omitted)
- `type:` (`:text | :number | :email | :password | :textarea`, default `:text`)
- `required:` (Boolean, default `false`) — shows a red asterisk after the label
- `hint:` (String) — help text below the input
- `placeholder:` (String)
- `min:` / `max:` (for number inputs)

```erb
<%= ui_form_field(
  attribute: :name,
  label: "List Name",
  required: true,
  hint: "Enter a descriptive name"
) %>
```

### `ui_input`

Renders a standalone `<input>` element with consistent styling.

**Required props**

- `name:` (String)

**Optional props**

- `type:` (`:text | :number | :email | :password`, default `:text`)
- `value:` (String/Number)
- `placeholder:` (String)
- `disabled:` (Boolean, default `false`)
- `min:` / `max:` / `step:` (for number type)

```erb
<%= ui_input(name: "search", placeholder: "Search...") %>
<%= ui_input(name: "quantity", type: :number, value: 1, min: 1) %>
```

### `ui_textarea`

Renders a multi-line `<textarea>` element with consistent styling.

**Required props**

- `name:` (String)

**Optional props**

- `value:` (String)
- `rows:` (Integer, default `3`)
- `placeholder:` (String)
- `disabled:` (Boolean, default `false`)

```erb
<%= ui_textarea(name: "notes", rows: 5, placeholder: "Add notes...") %>
```

### `ui_page_header`

Renders a page title area with an optional subtitle and action slot. On small screens the title stacks above actions; on wider screens they sit side-by-side.

**Required props**

- `title:` (String) — the page heading

**Optional props**

- `subtitle:` (String) — secondary text below the title

**Block API** — register an action slot via `header.action`:

```erb
<%= ui_page_header(title: "Products", subtitle: "Manage your catalog") do |header| %>
  <% header.action do %>
    <%= ui_button(label: "New Product", href: new_product_path) %>
  <% end %>
<% end %>
```

### `ui_alert`

Renders a styled alert/flash message with type variants, optional title, and dismissible button.

**Required props**

- `message:` (String) — the alert message

**Optional props**

- `type:` (`:info | :success | :warning | :error`, default `:info`) — determines background/text color
- `title:` (String) — bold title above the message
- `dismissible:` (Boolean, default `false`) — shows a dismiss button when `true`

```erb
<%= ui_alert(message: "Changes saved successfully.", type: :success) %>
<%= ui_alert(message: "Could not save record.", type: :error, title: "Error", dismissible: true) %>
```
