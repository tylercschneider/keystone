# frozen_string_literal: true

namespace :keystone do
  desc "Inject @source path into application.css for Tailwind to scan component files"
  task inject_source: :environment do
    css_path = Rails.root.join("app/assets/tailwind/application.css")
    next unless css_path.exist?

    content = css_path.read
    marker = "/* keystone:source */"
    gem_path = KeystoneUi::Engine.root
    source_line = "#{marker} @source \"#{gem_path}/app/components/**/*.{erb,rb}\";"

    if content.include?(marker)
      updated = content.sub(/#{Regexp.escape(marker)}.*$/, source_line)
      css_path.write(updated)
    end
  end

  desc "Restore marker-only line after Tailwind build (no local path committed)"
  task :clean_source do
    css_path = Rails.root.join("app/assets/tailwind/application.css")
    next unless css_path.exist?

    content = css_path.read
    marker = "/* keystone:source */"

    if content.include?(marker)
      updated = content.sub(/#{Regexp.escape(marker)}.*$/, marker)
      css_path.write(updated)
    end
  end

  desc "Append Keystone UI API reference to CLAUDE.md"
  task :claude do
    section_heading = "## Keystone UI"

    content = <<~MARKDOWN
      #{section_heading}

      Keystone UI is a ViewComponent gem. Use the helpers below in your ERB views.

      ### `ui_card`

      ```erb
      <%= ui_card(title: "…", summary: "…", link: "…") %>
      <%= ui_card(title: "…", summary: "…", link: "…", cta: "Learn more") %>
      ```

      | Param | Required | Default |
      |-------|----------|---------|
      | `title:` | yes | — |
      | `summary:` | yes | — |
      | `link:` | yes | — |
      | `cta:` | no | `"Read more"` |
      | `edge_to_edge:` | no | `false` | removes side borders/radius on mobile when `true` |

      ### `ui_button`

      ```erb
      <%= ui_button(label: "Save") %>
      <%= ui_button(label: "Visit", href: "/path", variant: :secondary, size: :lg) %>
      ```

      | Param | Required | Default | Values |
      |-------|----------|---------|--------|
      | `label:` | yes | — | — |
      | `href:` | no | `nil` | renders `<a>` when set, `<button>` otherwise |
      | `variant:` | no | `:primary` | `:primary`, `:secondary`, `:danger` |
      | `size:` | no | `:md` | `:sm`, `:md`, `:lg` |

      ### `ui_data_table`

      ```erb
      <%= ui_data_table(items: @users, columns: [{ name: "Name" }, { email: "Email" }]) %>
      ```

      **With Column objects** (for per-column options like `mobile_hidden`):

      ```erb
      <%
        columns = [
          Keystone::Ui::Column.new(:name, "Name"),
          Keystone::Ui::Column.new(:email, "Email", mobile_hidden: true)
        ]
      %>
      <%= ui_data_table(items: @users, columns: columns) %>
      ```

      **Block API** — links and actions:

      ```erb
      <%= ui_data_table(items: @users, columns: [{ name: "Name" }, { email: "Email" }]) do |table| %>
        <% table.link(:name) { |user| user_path(user) } %>
        <% table.actions do |user| %>
          <%= link_to "Edit", edit_user_path(user) %>
        <% end %>
      <% end %>
      ```

      | Param | Required | Default |
      |-------|----------|---------|
      | `items:` | yes | — |
      | `columns:` | yes | array of `{ key: "Label" }` hashes or `Column` objects |
      | `empty_message:` | no | `nil` |

      `Column.new(key, header_text, mobile_hidden: false)` — use `mobile_hidden: true` to hide a column on small screens.

      ### `ui_page`

      ```erb
      <%= ui_page(max_width: :lg) do %>
        <!-- page content -->
      <% end %>
      ```

      | Param | Required | Default | Values |
      |-------|----------|---------|--------|
      | `max_width:` | no | `:full` | `:sm`, `:md`, `:lg`, `:xl`, `:full` |
      | `padding:` | no | `:standard` | `:standard`, `:none` |

      ### `ui_section`

      ```erb
      <%= ui_section(title: "Products", subtitle: "All active items") do %>
        <!-- section content -->
      <% end %>
      ```

      | Param | Required | Default | Values |
      |-------|----------|---------|--------|
      | `title:` | no | `nil` | — |
      | `subtitle:` | no | `nil` | — |
      | `action:` | no | `nil` | slot for a trailing action |
      | `spacing:` | no | `:md` | `:sm`, `:md`, `:lg` |

      ### `ui_grid`

      ```erb
      <%= ui_grid(cols: { default: 1, sm: 2, lg: 4 }, gap: :lg) do %>
        <!-- grid items -->
      <% end %>
      ```

      | Param | Required | Default | Values |
      |-------|----------|---------|--------|
      | `cols:` | no | `{ default: 1 }` | hash of breakpoint → column count (1-12). Keys: `:default`, `:sm`, `:md`, `:lg` |
      | `gap:` | no | `:md` | `:sm`, `:md`, `:lg`, `:xl` |
      | `gap_x:` | no | `nil` | overrides `gap:` horizontally |
      | `gap_y:` | no | `nil` | overrides `gap:` vertically |

      ### `ui_panel`

      ```erb
      <%= ui_panel(padding: :lg) do %>
        <!-- panel content -->
      <% end %>
      ```

      | Param | Required | Default | Values |
      |-------|----------|---------|--------|
      | `padding:` | no | `:md` | `:sm`, `:md`, `:lg` |
      | `radius:` | no | `:lg` | `:md`, `:lg`, `:xl` |
      | `shadow:` | no | `true` | `true`, `false` |

      ### `ui_card_link`

      ```erb
      <%= ui_card_link(href: product_path(@product)) do %>
        <h3>Product name</h3>
      <% end %>
      ```

      | Param | Required | Default | Values |
      |-------|----------|---------|--------|
      | `href:` | yes | — | — |
      | `padding:` | no | `:md` | `:sm`, `:md`, `:lg` |
      | `shadow:` | no | `true` | `true`, `false` |

      ### `ui_page_header`

      ```erb
      <%= ui_page_header(title: "Products", subtitle: "Manage your catalog") do |header| %>
        <% header.action do %>
          <%= ui_button(label: "New Product", href: new_product_path) %>
        <% end %>
      <% end %>
      ```

      | Param | Required | Default |
      |-------|----------|---------|
      | `title:` | yes | — |
      | `subtitle:` | no | `nil` |

      Block API: call `header.action { ... }` to add an action slot (e.g. a button) aligned to the right.

      ### `ui_alert`

      ```erb
      <%= ui_alert(message: "Changes saved.", type: :success) %>
      <%= ui_alert(message: "Could not save.", type: :error, title: "Error", dismissible: true) %>
      ```

      | Param | Required | Default | Values |
      |-------|----------|---------|--------|
      | `message:` | yes | — | — |
      | `type:` | no | `:info` | `:info`, `:success`, `:warning`, `:error` |
      | `title:` | no | `nil` | bold title above message |
      | `dismissible:` | no | `false` | shows dismiss button when `true` |
    MARKDOWN

    content.chomp!

    path = File.join(Dir.pwd, "CLAUDE.md")

    if File.exist?(path)
      existing = File.read(path)

      if existing.include?(section_heading)
        updated = existing.sub(/#{Regexp.escape(section_heading)}\n.*\z/m, "#{content}\n")
        File.write(path, updated)
      else
        File.write(path, "#{existing.chomp}\n\n#{content}\n")
      end
    else
      File.write(path, "#{content}\n")
    end

    puts "Keystone UI API reference written to #{path}"
  end
end
