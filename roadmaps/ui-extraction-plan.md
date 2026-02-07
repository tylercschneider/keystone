# Keystone UI Extraction Plan

Comprehensive plan for extracting reusable UI components from the w2 app into the keystone gem. All components must work with Hotwire Native iOS as the primary delivery surface.

---

## Current State

### Already in Keystone (v0.1.0)
- `ui_button` — `<a>` or `<button>`, variants (primary/secondary/danger), sizes (sm/md/lg)
- `ui_card` — title, summary, CTA link
- `ui_data_table` — responsive table with linkable cells, actions column, mobile-hidden columns, empty state

### In Use in w2
- `ui_data_table` in shopping lists index and items section
- CSS variable theming (base + dark)

### Remaining in w2 (Extraction Candidates)
- Page wrappers with inconsistent `px-4 sm:px-6 lg:px-8` spacing
- Metric cards with value, label, delta/trend indicators, variant backgrounds
- Dashboard widget system (config-driven rendering with ordered visibility)
- Checklist items with checkboxes, strikethrough, form-submit-on-change
- Section cards (rounded-2xl border containers with header + content)
- Status badges (colored pills for status/type indicators)
- Empty states (centered message + CTA)
- Progress bars (sized, colored by percentage)
- Form groups (label + input + hint + error)

---

## Hotwire Native Compatibility Strategy

Components must work correctly inside a Turbo-powered WebView on iOS. Hotwire Native runs all JavaScript in WKWebView, so Stimulus controllers work identically in the browser and in the native app.

### Principles

1. **44px minimum touch targets** — all interactive elements (buttons, checkboxes, links in tables/lists) get `min-h-[44px]` and adequate tap area. This is an iOS HIG requirement.

2. **No bridge coupling** — bridge controllers (`bridge--form`, `bridge--menu-button`, etc.) live in consuming apps. Components emit standard HTML/data attributes that bridge controllers can hook into. Keystone never imports `@hotwired/hotwire-native-bridge`.

3. **Stimulus where needed** — keystone ships small, focused Stimulus controllers for components that require interactivity (dismissible alerts, dropdown menus, collapsible widgets). These work identically in browser and native WebView. Components that don't need JS (layout, display, forms, checklists) ship none.

4. **Stimulus opt-in registration** — keystone does NOT auto-register controllers. Consuming apps import and register explicitly:
   ```js
   import { Alert, Dropdown, Toggle } from "keystone-components"
   application.register("keystone--alert", Alert)
   application.register("keystone--dropdown", Dropdown)
   application.register("keystone--toggle", Toggle)
   ```

5. **Form bridge compatibility** — form components render standard `[type="submit"]` buttons. The existing CSS rule `[data-bridge-components~="form"] [type="submit"] { display: none; }` works automatically — no changes needed in keystone.

6. **Safe area awareness** — wrapper/layout components include `env(safe-area-inset-*)` padding where appropriate (bottom nav, sticky footers). This is handled via CSS in the theme layer.

7. **No conditional rendering** — components don't check `hotwire_native_app?`. Consuming apps handle show/hide decisions. Components just render correct, accessible HTML.

8. **Responsive by default** — all components work at mobile widths (320px+). No component assumes desktop layout.

### Stimulus Controllers Shipped by Keystone

| Controller | Used By | Behavior |
|------------|---------|----------|
| `keystone--alert` | `ui_alert` (when `dismissible: true`) | Hide on click, optional auto-dismiss timeout |
| `keystone--dropdown` | `ui_dropdown_menu` | Open/close, click-outside-to-close |
| `keystone--toggle` | `ui_widget` (when `collapsible: true`) | Toggle content visibility |

### Components That Don't Need Stimulus

| Component | Why |
|-----------|-----|
| `ui_checklist_item` | Uses native `requestSubmit()` on checkbox change |
| `ui_tabs` | Each tab is a plain `<a>` link — Turbo handles navigation |
| `ui_form_field`, `ui_switch` | Standard form elements — bridge--form CSS handles native |
| `ui_page`, `ui_section`, `ui_grid`, `ui_panel` | Pure layout — no interactivity |
| `ui_stat_card`, `ui_badge`, `ui_empty_state`, `ui_progress` | Pure display |

---

## Phase 1: Layout Foundation

**Goal:** Eliminate inconsistent spacing. Every page and section uses the same edge distances and vertical rhythm. This is the foundation everything else sits on.

### `ui_page`
Consistent page wrapper with responsive horizontal padding and optional max-width.

```erb
<%= ui_page do %>
  <h1>Dashboard</h1>
  <!-- page content -->
<% end %>

<%= ui_page(max_width: :lg) do %>
  <!-- constrained width content -->
<% end %>
```

**Props:**
- `max_width:` (`:sm | :md | :lg | :xl | :full`, default `:full`)
- `padding:` (`:standard | :none`, default `:standard`)
- Block yields page content

**Markup:**
```html
<div class="ui-page px-4 sm:px-6 lg:px-8">
  <!-- content -->
</div>
```

**Replaces in w2:** Every `<div class="px-4 sm:px-6 lg:px-8">` wrapper (dashboard/show, account_dashboards/show, all index pages).

### `ui_section`
Vertical section with consistent top margin and optional title.

```erb
<%= ui_section(title: "Active Goals", action: { label: "View All", href: goals_path }) do %>
  <!-- section content -->
<% end %>
```

**Props:**
- `title:` (String, optional)
- `subtitle:` (String, optional)
- `action:` (Hash `{ label:, href: }`, optional — rendered as link in header row)
- `spacing:` (`:sm | :md | :lg`, default `:md`) — controls top margin
- Block yields section content

**Markup:**
```html
<div class="ui-section mt-6">
  <div class="flex items-center justify-between mb-4">
    <h2 class="text-lg font-semibold ...">Active Goals</h2>
    <a href="..." class="text-sm ...">View All</a>
  </div>
  <!-- content -->
</div>
```

### `ui_grid`
Responsive CSS grid with consistent gaps.

```erb
<%= ui_grid(cols: { default: 1, sm: 2, lg: 4 }, gap: :md) do %>
  <%= ui_stat_card(...) %>
  <%= ui_stat_card(...) %>
  <%= ui_stat_card(...) %>
  <%= ui_stat_card(...) %>
<% end %>
```

**Props:**
- `cols:` (Hash `{ default:, sm:, md:, lg: }` — responsive column counts)
- `gap:` (`:sm | :md | :lg`, default `:md`)
- Block yields grid items

**Markup:**
```html
<div class="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">
  <!-- items -->
</div>
```

### `ui_panel`
The rounded card container used everywhere in w2 — the "section card" wrapper.

```erb
<%= ui_panel do %>
  <p>Content inside a bordered card</p>
<% end %>

<%= ui_panel(padding: :lg, radius: :xl) do %>
  <!-- more spacious card -->
<% end %>
```

**Props:**
- `padding:` (`:sm | :md | :lg`, default `:md`) — maps to `p-4`, `p-5`, `p-6`
- `radius:` (`:md | :lg | :xl`, default `:lg`) — maps to `rounded-lg`, `rounded-xl`, `rounded-2xl`
- `shadow:` (Boolean, default `true`)
- Block yields panel content

**Markup:**
```html
<div class="rounded-2xl border border-gray-200 bg-white p-6 shadow-sm dark:bg-zinc-900 dark:border-zinc-700">
  <!-- content -->
</div>
```

**Replaces in w2:** Every `rounded-2xl border border-gray-200 bg-white p-6 shadow-sm dark:bg-zinc-900 dark:border-zinc-700` card container.

### CSS Tokens Required
```css
--color-bg-page: ...;
--color-bg-panel: ...;
--color-border-panel: ...;
--spacing-page-x: ...;
--spacing-section-gap: ...;
```

### Migration Steps
1. Build components in keystone with specs
2. Add `ui_page`, `ui_section`, `ui_grid`, `ui_panel` helpers
3. In w2: replace `<div class="px-4 sm:px-6 lg:px-8">` wrappers with `<%= ui_page %>`
4. Replace card containers with `<%= ui_panel %>`
5. Verify on iOS simulator — check edge spacing, safe areas, scroll behavior

---

## Phase 2: Display Atoms

**Goal:** Extract the small, reusable display elements that appear inside panels and sections.

### `ui_stat_card`
Dashboard metric display with optional comparison delta. Extracted from `_metric_card.html.erb`.

```erb
<%= ui_stat_card(
  label: "Total Spend",
  value: "$1,234",
  comparison: { delta: 150, delta_percent: 12 },
  variant: :default
) %>
```

**Props:**
- `label:` (String, required)
- `value:` (String/Number, required)
- `comparison:` (Hash `{ delta:, delta_percent: }`, optional)
- `variant:` (`:default | :warning | :danger | :neutral`, default `:default`)
- `href:` (String, optional — makes entire card a link)

**Markup:** Rounded card with label (sm gray), value (2xl semibold), optional up/down arrow with colored delta text.

**Touch target:** When `href` is present, entire card is tappable with min-h-[44px].

### `ui_badge`
Status pill/tag. Used across tasks, shopping lists, recipes, areas.

```erb
<%= ui_badge(text: "Active", variant: :success) %>
<%= ui_badge(text: "3 remaining", variant: :info, size: :sm) %>
```

**Props:**
- `text:` (String, required)
- `variant:` (`:neutral | :success | :warning | :danger | :info`, default `:neutral`)
- `size:` (`:sm | :md`, default `:md`)

**Markup:**
```html
<span class="inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-300">
  Active
</span>
```

### `ui_empty_state`
Placeholder for empty collections. Used in dashboard (no tasks), shopping lists (no items), goals (no active goals).

```erb
<%= ui_empty_state(
  title: "No tasks ready to work on.",
  description: "Create a goal to get started.",
  action: { label: "Create a goal", href: new_goal_path }
) %>
```

**Props:**
- `title:` (String, required)
- `description:` (String, optional)
- `icon:` (Symbol, optional — predefined icon set or block for custom)
- `action:` (Hash `{ label:, href: }`, optional)

### `ui_progress`
Progress bar. Extracted from `shared/_progress_bar.html.erb`.

```erb
<%= ui_progress(percent: 75, size: :sm) %>
<%= ui_progress(current: 5, total: 12, label: "Tasks", show_percent: true) %>
```

**Props:**
- `percent:` (Integer, 0-100) — OR — `current:` + `total:` (auto-calculates)
- `size:` (`:sm | :md | :lg`, default `:md`)
- `label:` (String, optional)
- `show_percent:` (Boolean, default `false`)
- `variant:` (`:default | :success | :warning | :danger`, default auto by percentage)

### CSS Tokens Required
```css
/* Stat card */
--color-stat-card-bg: ...;
--color-stat-card-border: ...;
--color-stat-card-bg-warning: ...;
--color-stat-card-bg-danger: ...;

/* Badges */
--color-badge-success-bg: ...;
--color-badge-success-text: ...;
--color-badge-warning-bg: ...;
--color-badge-warning-text: ...;
--color-badge-danger-bg: ...;
--color-badge-danger-text: ...;
--color-badge-info-bg: ...;
--color-badge-info-text: ...;
--color-badge-neutral-bg: ...;
--color-badge-neutral-text: ...;

/* Trend colors */
--color-trend-up: ...;     /* green */
--color-trend-down: ...;   /* red */

/* Progress */
--color-progress-track: ...;
--color-progress-fill: ...;
```

### Migration Steps
1. Build all four components with specs
2. Add helpers to `keystone_ui_helper.rb`
3. In w2: replace `_metric_card.html.erb` renders with `ui_stat_card`
4. Replace inline badge markup with `ui_badge`
5. Replace `_progress_bar.html.erb` with `ui_progress`
6. Replace empty-state `<div class="text-center py-8">` blocks with `ui_empty_state`
7. Delete the replaced partials from w2
8. Test on iOS — check badge legibility at mobile sizes, tap targets on stat cards

---

## Phase 3: Checklist Component

**Goal:** Extract the shopping item checkbox pattern into a reusable checklist. This is the "specialty table with checkmarks" — distinct from DataTable.

### `ui_checklist_item`
Single item with checkbox, content area, and actions. Submits form on toggle.

```erb
<%= ui_checklist_item(
  checked: item.purchased?,
  toggle_url: toggle_purchased_path(item),
  toggle_method: :post,
  dom_id: dom_id(item)
) do |ci| %>
  <% ci.content do %>
    <%= link_to item.name, item_path(item) %>
    <span class="ml-2 text-sm text-gray-500">x<%= item.quantity %></span>
  <% end %>
  <% ci.actions do %>
    <%= link_to "Edit", edit_path(item) %>
  <% end %>
<% end %>
```

**Props:**
- `checked:` (Boolean, default `false`)
- `toggle_url:` (String, optional — if present, checkbox submits via form)
- `toggle_method:` (Symbol, default `:post`)
- `strikethrough:` (Boolean, default `true` — strike content when checked)
- `disabled:` (Boolean, default `false`)
- `dom_id:` (String, optional — for Turbo Stream targeting)

**Slots:**
- `content` — main content area (flex-1, min-w-0 for truncation)
- `actions` — right-side action buttons

**Markup:**
```html
<div id="item_123" class="flex items-center gap-3 py-2 min-h-[52px]">
  <form action="..." method="post">
    <label class="flex items-center justify-center w-11 h-11 cursor-pointer">
      <input type="checkbox" class="h-6 w-6 rounded ..." onchange="this.form.requestSubmit()">
    </label>
  </form>
  <div class="flex-1 min-w-0"><!-- content slot --></div>
  <div class="flex items-center"><!-- actions slot --></div>
</div>
```

**Hotwire Native notes:**
- 44px label wrapper ensures adequate touch target
- `requestSubmit()` works in WebView (no custom JS needed)
- Turbo Stream responses update the item in-place
- No bridge dependency — standard form submission

### `ui_checklist`
Optional wrapper for a list of checklist items with grouped sections.

```erb
<%= ui_checklist do |list| %>
  <% list.group(title: "Produce") do %>
    <%= ui_checklist_item(...) %>
    <%= ui_checklist_item(...) %>
  <% end %>
  <% list.group(title: "Dairy") do %>
    <%= ui_checklist_item(...) %>
  <% end %>
<% end %>
```

**Props:**
- `divided:` (Boolean, default `true` — adds `divide-y` between items)

**Slots:**
- `group(title:)` — optional grouped sections with header labels

### Migration Steps
1. Build `ui_checklist_item` component + spec
2. Build `ui_checklist` wrapper component + spec
3. Add helpers
4. In w2: replace `_shopping_item.html.erb` with `ui_checklist_item`
5. Replace grouped shopping view with `ui_checklist` groups
6. Test on iOS — verify checkbox tap target, form submission, Turbo Stream updates

---

## Phase 4: Form Components

**Goal:** Extract form patterns for reuse. Forms are the highest-frequency UI in CRUD apps.

### `ui_form_field`
Complete form field: label + input + hint + error. Works with Rails form builders.

```erb
<%= form_with model: @item do |f| %>
  <%= ui_form_field(form: f, attribute: :name, label: "Item Name", required: true) %>
  <%= ui_form_field(form: f, attribute: :quantity, type: :number, min: 1) %>
  <%= ui_form_field(form: f, attribute: :notes, type: :textarea, hint: "Optional notes") %>
<% end %>
```

**Props:**
- `form:` (ActionView form builder, required)
- `attribute:` (Symbol, required)
- `label:` (String, optional — inferred from attribute if omitted)
- `type:` (`:text | :number | :email | :password | :textarea | :select`, default `:text`)
- `required:` (Boolean, default `false`)
- `hint:` (String, optional)
- `placeholder:` (String, optional)
- `options:` (Array, for `:select` type)
- `min:` / `max:` / `step:` (for `:number` type)
- `rows:` (Integer, for `:textarea` type, default `3`)

**Markup:**
```html
<div class="ui-form-group">
  <label class="ui-form-label" for="item_name">
    Item Name <span class="text-red-500">*</span>
  </label>
  <input type="text" class="ui-form-control" id="item_name" name="item[name]">
  <p class="ui-form-hint">Optional hint text</p>
  <p class="ui-form-error">Name can't be blank</p>
</div>
```

**Error display:** Automatically renders validation errors from `form.object.errors[attribute]`.

### `ui_switch`
Toggle switch for boolean fields.

```erb
<%= ui_switch(form: f, attribute: :active, label: "Active") %>
```

**Props:**
- `form:` (form builder, optional — standalone if omitted)
- `attribute:` (Symbol)
- `label:` (String)
- `checked:` (Boolean, for standalone usage)
- `name:` (String, for standalone usage)

### Hotwire Native Form Notes
- Form components render standard `<input>`, `<select>`, `<textarea>` elements
- The bridge--form controller hides `[type="submit"]` buttons automatically via CSS
- Native iOS provides its own submit button in the navigation bar
- No changes needed in keystone — existing CSS rule handles it
- Focus behavior: inputs get proper `inputmode` attributes for iOS keyboard optimization (e.g., `inputmode="numeric"` for number fields)

### CSS Tokens Required
```css
--color-input-bg: ...;
--color-input-border: ...;
--color-input-focus-ring: ...;
--color-input-error-border: ...;
--color-form-label: ...;
--color-form-hint: ...;
--color-form-error: ...;
```

### Migration Steps
1. Build `ui_form_field` component with specs for each type
2. Build `ui_switch` component with spec
3. Add helpers
4. In w2: convert one form at a time (start with simplest — shopping list item form)
5. Test on iOS — verify keyboard types, focus behavior, error display, bridge form submit
6. Gradually migrate remaining forms

---

## Phase 5: Dashboard & Widget System

**Goal:** Extract the configurable dashboard pattern. This is the most complex phase — it involves composition of the components from phases 1-4.

### `ui_dashboard`
Top-level dashboard container with optional settings/controls area.

```erb
<%= ui_dashboard do |dash| %>
  <% dash.header do %>
    <h1>Account Dashboard</h1>
  <% end %>

  <% dash.controls do %>
    <%= render "controls" %>
  <% end %>

  <% dash.widgets do %>
    <%= ui_widget(title: "Key Metrics") do %>
      <%= ui_grid(cols: { default: 1, sm: 2, lg: 4 }) do %>
        <%= ui_stat_card(label: "Revenue", value: "$42K") %>
      <% end %>
    <% end %>
  <% end %>
<% end %>
```

**Props:**
- Block yields dashboard for `header`, `controls`, `widgets` slots

**Slots:**
- `header` — title area with optional actions
- `controls` — filters, time period selectors (app-specific content)
- `widgets` — main widget area

### `ui_widget`
Individual widget container — the consistent wrapper around each dashboard section.

```erb
<%= ui_widget(title: "Spending Trend") do %>
  <%= line_chart @chart_data %>
<% end %>

<%= ui_widget(title: "Top Items", collapsible: true) do %>
  <%= bar_chart @bar_data %>
<% end %>
```

**Props:**
- `title:` (String, required)
- `subtitle:` (String, optional)
- `collapsible:` (Boolean, default `false`)
- `data_widget:` (String, optional — data attribute for targeting)
- Block yields widget content

**Markup:**
```html
<div class="mt-6" data-widget="spending_trend">
  <h2 class="text-lg font-medium ... mb-4">Spending Trend</h2>
  <div class="rounded-lg border ... bg-white p-4 ...">
    <!-- content -->
  </div>
</div>
```

### What Stays in w2
- Dashboard configuration model (ordered_visible_widgets, widget_visible?)
- Specific widget content (charts, domain-specific metrics)
- Settings modal
- The iteration logic that decides which widgets to render

Keystone provides the **containers** (dashboard layout, widget wrappers). The app provides the **content** (what goes inside each widget).

### Migration Steps
1. Build `ui_widget` component + spec
2. Build `ui_dashboard` component + spec
3. Add helpers
4. In w2: wrap each widget partial's outer div with `ui_widget`
5. Wrap the dashboard page with `ui_dashboard`
6. Remove redundant wrapper markup from widget partials
7. Test on iOS — verify scroll behavior, widget spacing, collapsible sections

---

## Phase 6: Polish & Refinement

### `ui_alert`
Flash messages and inline notifications.

```erb
<%= ui_alert(type: :success, message: "Item saved!") %>
<%= ui_alert(type: :error, message: "Could not save", dismissible: true) %>
```

### `ui_page_header`
Consistent page header with title and optional action buttons.

```erb
<%= ui_page_header(title: "Shopping Lists") do |header| %>
  <% header.action { ui_button(label: "New List", href: new_path, variant: :primary) } %>
<% end %>
```

### `ui_tabs`
Tab navigation for filtered views.

```erb
<%= ui_tabs(active: :all) do |tabs| %>
  <% tabs.tab(:all, label: "All", href: items_path) %>
  <% tabs.tab(:low, label: "Low Stock", href: items_path(filter: :low), count: 5) %>
<% end %>
```

### `ui_dropdown_menu`
Action menus for table rows and card actions.

```erb
<%= ui_dropdown_menu do |menu| %>
  <% menu.item(label: "Edit", href: edit_path) %>
  <% menu.divider %>
  <% menu.item(label: "Delete", href: path, variant: :danger, method: :delete) %>
<% end %>
```

---

## Spacing & Wrapper Refinement Notes

### Current Problems in w2
1. **Nested padding** — `account_dashboards/show.html.erb` has `px-4 sm:px-6 lg:px-8` on the outer div AND on nested widget divs, causing double padding
2. **Inconsistent card radius** — some cards use `rounded-lg`, others `rounded-2xl`
3. **Inconsistent card padding** — `p-4` on widget cards, `p-6` on dashboard cards
4. **Manual spacing** — `mt-6`, `mt-8` scattered with no system
5. **DataTable includes its own padding** — the table template has `px-4 sm:px-6 lg:px-8` baked in, which conflicts when placed inside `ui_page`

### Resolution
- `ui_page` owns the horizontal padding — no inner component should add `px-*`
- `ui_panel` standardizes card styling (radius, padding, border, shadow)
- `ui_section` standardizes vertical spacing between sections
- `ui_widget` standardizes dashboard widget spacing
- **DataTable refactor:** remove the outer `px-4 sm:px-6 lg:px-8` wrapper from the DataTable template. The consuming page provides the page-level padding via `ui_page`. DataTable just renders the table.

### Standard Spacing Scale
| Token | Value | Use |
|-------|-------|-----|
| `--spacing-xs` | `0.5rem` (8px) | Tight gaps |
| `--spacing-sm` | `0.75rem` (12px) | Related elements |
| `--spacing-md` | `1rem` (16px) | Default gap |
| `--spacing-lg` | `1.5rem` (24px) | Section spacing |
| `--spacing-xl` | `2rem` (32px) | Major sections |

### Standard Responsive Padding
```
Page horizontal: px-4 sm:px-6 lg:px-8  (16 / 24 / 32px)
Panel internal:  p-4 sm:p-5 lg:p-6     (16 / 20 / 24px)
```

---

## Implementation Sequence

| Phase | Components | Est. Effort | Depends On |
|-------|------------|-------------|------------|
| 1 | `ui_page`, `ui_section`, `ui_grid`, `ui_panel` | Small | — |
| 2 | `ui_stat_card`, `ui_badge`, `ui_empty_state`, `ui_progress` | Medium | Phase 1 |
| 3 | `ui_checklist_item`, `ui_checklist` | Medium | Phase 1 |
| 4 | `ui_form_field`, `ui_switch` | Medium | Phase 1 |
| 5 | `ui_dashboard`, `ui_widget` | Medium | Phase 1, 2 |
| 6 | `ui_alert`, `ui_page_header`, `ui_tabs`, `ui_dropdown_menu` | Medium | Phase 1 |

Phases 2, 3, 4, and 6 can be worked in parallel after Phase 1 is complete.

### Per-Component Workflow (TDD)
1. Write RSpec for component class (props, defaults, edge cases)
2. Build ViewComponent class with explicit kwargs
3. Create `.html.erb` template with semantic classes
4. Add CSS tokens to `base.css` and `dark.css`
5. Add thin helper to `keystone_ui_helper.rb`
6. In w2: swap one usage, verify behavior
7. Migrate remaining usages
8. Delete replaced partial from w2
9. Test on iOS simulator

### DataTable Breaking Change (v0.2.0)
Phase 1 includes removing the baked-in `px-4 sm:px-6 lg:px-8` wrapper from DataTable's template. **Decision: clean break, bump to v0.2.0.** Only w2 consumes it today. In w2, wrap existing `ui_data_table` calls with `ui_page` to restore the page padding.

---

## Theme Expansion

The current theme has tokens for cards, buttons, and text. Each phase adds tokens for its components. Full token list after all phases:

```css
:root {
  /* Existing */
  --color-bg-card: ...;
  --color-fg-card: ...;
  --color-border-card: ...;
  --color-primary: ...;
  --color-secondary: ...;
  --color-danger: ...;

  /* Phase 1: Layout */
  --color-bg-page: ...;
  --color-bg-panel: ...;
  --color-border-panel: ...;

  /* Phase 2: Display */
  --color-badge-success-bg: ...;
  --color-badge-success-text: ...;
  --color-badge-warning-bg: ...;
  --color-badge-warning-text: ...;
  --color-badge-danger-bg: ...;
  --color-badge-danger-text: ...;
  --color-badge-info-bg: ...;
  --color-badge-info-text: ...;
  --color-badge-neutral-bg: ...;
  --color-badge-neutral-text: ...;
  --color-trend-up: ...;
  --color-trend-down: ...;
  --color-progress-track: ...;
  --color-progress-fill: ...;

  /* Phase 4: Forms */
  --color-input-bg: ...;
  --color-input-border: ...;
  --color-input-focus-ring: ...;
  --color-input-error-border: ...;
  --color-form-label: ...;
  --color-form-hint: ...;
  --color-form-error: ...;

  /* Phase 6: Alerts */
  --color-alert-success-bg: ...;
  --color-alert-success-text: ...;
  --color-alert-warning-bg: ...;
  --color-alert-warning-text: ...;
  --color-alert-error-bg: ...;
  --color-alert-error-text: ...;
  --color-alert-info-bg: ...;
  --color-alert-info-text: ...;
}
```

---

## Decisions Made

1. **DataTable padding removal** — **Option B (clean break).** Remove the baked-in `px-4 sm:px-6 lg:px-8` wrapper from DataTable's template. Bump to v0.2.0. Only w2 uses it today — wrap with `ui_page` instead.

2. **Icon system** — **Accept blocks from consuming apps.** Every app has different icon preferences (Heroicons, custom SVGs, etc.). Components that need a default icon (trend arrows in `ui_stat_card`, empty state placeholder) ship minimal inline SVGs. The API accepts a block override:
   ```erb
   <%= ui_empty_state(title: "No items") do |es| %>
     <% es.icon do %>
       <%= heroicon("clipboard", variant: :outline) %>
     <% end %>
   <% end %>
   ```

3. **Card consolidation** — **Keep both.** `ui_card` is a structured content card (title + summary + CTA). `ui_panel` is a generic container (border/shadow/radius wrapper). Different purposes, no overlap in practice.

4. **Stimulus controllers** — **Ship them where needed.** Keystone ships small, focused Stimulus controllers for components that require interactivity (dismissible alerts, dropdown menus, collapsible widgets). Consuming apps opt in by importing and registering. Controllers work identically in browser and Hotwire Native WebView.
