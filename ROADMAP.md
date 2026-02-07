# Keystone Components Roadmap

This document outlines planned components for the Keystone UI framework.

## Current Components

- **ui_card** - Card layout with title, summary, and CTA
- **ui_button** - Button/link with variants and sizes
- **ui_data_table** - Responsive data table with links and actions

---

## Planned Components

### Tier 1: Form Foundation

Essential for any CRUD application.

#### `ui_form_field`
Wraps label, input, hint, and error message in consistent layout.

```erb
<%= ui_form_field(
  form: f,
  attribute: :name,
  label: "List Name",
  required: true,
  hint: "Enter a descriptive name"
) %>
```

**Props:**
- `form:` (ActionView form builder, required)
- `attribute:` (Symbol, required)
- `label:` (String, optional - inferred from attribute)
- `type:` (`:text | :number | :email | :password | :textarea`, default `:text`)
- `required:` (Boolean, default `false`)
- `hint:` (String, optional)
- `placeholder:` (String, optional)
- `min:` / `max:` (for number inputs)

#### `ui_input`
Standalone input without form builder context.

```erb
<%= ui_input(name: "search", placeholder: "Search...", type: :text) %>
<%= ui_input(name: "quantity", type: :number, value: 1, min: 1) %>
```

**Props:**
- `name:` (String, required)
- `type:` (`:text | :number | :email | :password`, default `:text`)
- `value:` (String/Number, optional)
- `placeholder:` (String, optional)
- `disabled:` (Boolean, default `false`)
- `min:` / `max:` / `step:` (for number type)

#### `ui_textarea`
Multi-line text input.

```erb
<%= ui_textarea(name: "notes", rows: 3, placeholder: "Add notes...") %>
```

**Props:**
- `name:` (String, required)
- `value:` (String, optional)
- `rows:` (Integer, default `3`)
- `placeholder:` (String, optional)
- `disabled:` (Boolean, default `false`)

---

### Tier 2: Layout & Feedback

Common patterns for page structure and user feedback.

#### `ui_page_header`
Consistent page title area with optional actions.

```erb
<%= ui_page_header(title: "Shopping Lists", subtitle: "Manage your lists") do |header| %>
  <% header.action { ui_button(label: "New List", href: new_path) } %>
<% end %>
```

**Props:**
- `title:` (String, required)
- `subtitle:` (String, optional)
- Block yields header for `.action` calls

#### `ui_alert`
Flash messages and inline notifications.

```erb
<%= ui_alert(type: :success, message: "Item saved!") %>
<%= ui_alert(type: :error, title: "Error", message: "Could not save", dismissible: true) %>
```

**Props:**
- `message:` (String, required)
- `type:` (`:info | :success | :warning | :error`, default `:info`)
- `title:` (String, optional)
- `dismissible:` (Boolean, default `false`)

#### `ui_empty_state`
Placeholder for empty lists/collections.

```erb
<%= ui_empty_state(
  icon: :clipboard,
  title: "No items yet",
  description: "Add your first item to get started",
  action: { label: "Add Item", href: new_item_path }
) %>
```

**Props:**
- `title:` (String, required)
- `description:` (String, optional)
- `icon:` (Symbol, optional)
- `action:` (Hash with `:label` and `:href`, optional)

#### `ui_badge`
Status indicators and labels.

```erb
<%= ui_badge(text: "Draft", variant: :neutral) %>
<%= ui_badge(text: "Active", variant: :success) %>
<%= ui_badge(text: "Expired", variant: :danger) %>
```

**Props:**
- `text:` (String, required)
- `variant:` (`:neutral | :success | :warning | :danger | :info`, default `:neutral`)
- `size:` (`:sm | :md`, default `:md`)

---

### Tier 3: Interactive Elements

For richer user interactions.

#### `ui_checklist_item`
Interactive item with checkbox, content, and actions.

```erb
<%= ui_checklist_item(
  checked: item.purchased?,
  toggle_url: toggle_path(item),
  strikethrough: true
) do |ci| %>
  <% ci.content do %>
    <span class="font-medium"><%= item.name %></span>
    <span class="text-sm text-gray-500"><%= item.variant %></span>
  <% end %>
  <% ci.actions do %>
    <%= ui_button(label: "Edit", size: :sm, variant: :secondary) %>
  <% end %>
<% end %>
```

**Props:**
- `checked:` (Boolean, default `false`)
- `toggle_url:` (String, optional - if present, checkbox submits to URL)
- `strikethrough:` (Boolean, default `true` - strike content when checked)
- `disabled:` (Boolean, default `false`)
- Block yields item for `.content` and `.actions` slots

#### `ui_progress`
Progress bar with label.

```erb
<%= ui_progress(current: 5, total: 12, label: "Items purchased") %>
<%= ui_progress(percent: 75, show_percent: true) %>
```

**Props:**
- `current:` (Integer) + `total:` (Integer) — OR —
- `percent:` (Integer, 0-100)
- `label:` (String, optional)
- `show_percent:` (Boolean, default `false`)
- `variant:` (`:default | :success | :warning | :danger`, default `:default`)

#### `ui_modal`
Dialog overlay for confirmations and forms.

```erb
<%= ui_modal(id: "confirm-delete", title: "Delete List?") do |modal| %>
  <% modal.body do %>
    <p>This action cannot be undone.</p>
  <% end %>
  <% modal.footer do %>
    <%= ui_button(label: "Cancel", variant: :secondary, data: { action: "modal#close" }) %>
    <%= ui_button(label: "Delete", variant: :danger) %>
  <% end %>
<% end %>
```

**Props:**
- `id:` (String, required - for Stimulus targeting)
- `title:` (String, required)
- `size:` (`:sm | :md | :lg`, default `:md`)
- Block yields modal for `.body` and `.footer` slots

---

### Tier 4: Navigation & Data Display

For dashboards and complex views.

#### `ui_tabs`
Tab navigation.

```erb
<%= ui_tabs(active: :all) do |tabs| %>
  <% tabs.tab(:all, label: "All Items", href: items_path) %>
  <% tabs.tab(:low, label: "Low Stock", href: items_path(filter: :low), count: 5) %>
  <% tabs.tab(:expiring, label: "Expiring", href: items_path(filter: :expiring)) %>
<% end %>
```

**Props:**
- `active:` (Symbol, required - key of active tab)
- Block yields tabs for `.tab` calls
- Tab props: `key`, `label:`, `href:`, `count:` (optional badge)

#### `ui_stat_card`
Metric display for dashboards.

```erb
<%= ui_stat_card(
  label: "Items in Stock",
  value: 47,
  change: "+3",
  trend: :up
) %>
```

**Props:**
- `label:` (String, required)
- `value:` (String/Number, required)
- `change:` (String, optional - e.g., "+5%", "-3")
- `trend:` (`:up | :down | :neutral`, optional)
- `href:` (String, optional - makes card clickable)

#### `ui_dropdown_menu`
Action menu dropdown.

```erb
<%= ui_dropdown_menu(label: "Actions") do |menu| %>
  <% menu.item(label: "Edit", href: edit_path) %>
  <% menu.item(label: "Duplicate", href: duplicate_path) %>
  <% menu.divider %>
  <% menu.item(label: "Delete", href: delete_path, variant: :danger, method: :delete) %>
<% end %>
```

**Props:**
- `label:` (String, optional - default shows three dots icon)
- `align:` (`:left | :right`, default `:right`)
- Block yields menu for `.item` and `.divider` calls
- Item props: `label:`, `href:`, `variant:`, `method:`, `icon:`

---

### Tier 5: Specialized

Lower priority, build as needed.

#### `ui_select`
Styled select dropdown.

```erb
<%= ui_select(
  name: "status",
  options: [["Draft", "draft"], ["Active", "active"]],
  selected: "draft",
  include_blank: "Select status..."
) %>
```

#### `ui_checkbox`
Standalone checkbox.

```erb
<%= ui_checkbox(name: "agree", label: "I agree to the terms", checked: false) %>
```

#### `ui_avatar`
User avatar with fallback initials.

```erb
<%= ui_avatar(src: user.avatar_url, name: user.name, size: :md) %>
```

#### `ui_tooltip`
Hover tooltip.

```erb
<%= ui_tooltip(text: "More info here") do %>
  <span>Hover me</span>
<% end %>
```

---

## Implementation Priority

Based on consuming application needs (wyn3 shopping list & inventory):

| Phase | Components | Rationale |
|-------|------------|-----------|
| 1 | `ui_form_field`, `ui_input`, `ui_textarea` | Every form needs these |
| 2 | `ui_page_header`, `ui_alert` | Consistent page structure |
| 3 | `ui_badge`, `ui_empty_state` | Status display, empty states |
| 4 | `ui_checklist_item`, `ui_progress` | Active shopping mode |
| 5 | `ui_modal` | Confirmations, quick edits |
| 6 | `ui_stat_card`, `ui_tabs` | Inventory dashboard |
| 7 | `ui_dropdown_menu` | Table row actions |
| 8 | `ui_select`, `ui_checkbox` | Form enhancements |

---

## CSS Token Requirements

New components will need these semantic tokens added to themes:

```css
/* Alerts */
--color-alert-info-bg: ...;
--color-alert-info-text: ...;
--color-alert-success-bg: ...;
--color-alert-success-text: ...;
--color-alert-warning-bg: ...;
--color-alert-warning-text: ...;
--color-alert-error-bg: ...;
--color-alert-error-text: ...;

/* Badges */
--color-badge-neutral-bg: ...;
--color-badge-neutral-text: ...;
/* ... variants for success, warning, danger, info */

/* Progress */
--color-progress-track: ...;
--color-progress-fill: ...;

/* Forms */
--color-input-bg: ...;
--color-input-border: ...;
--color-input-focus: ...;
--color-input-error: ...;

/* Modal */
--color-overlay: rgba(0, 0, 0, 0.5);
```

---

## Development Guidelines

For each new component:

1. **Write spec first** - Define expected behavior in RSpec
2. **Build component class** - Ruby object with explicit kwargs
3. **Create template** - Minimal ERB with semantic classes
4. **Add helper** - Thin wrapper in `keystone_ui_helper.rb`
5. **Add theme tokens** - CSS variables in base.css and dark.css
6. **Document in README** - Props and usage examples
7. **Test in consuming app** - Verify in real usage context
