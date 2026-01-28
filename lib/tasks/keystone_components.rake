# frozen_string_literal: true

namespace :keystone do
  desc "Append Keystone Components API reference to CLAUDE.md"
  task :claude do
    section_heading = "## Keystone Components"

    content = <<~MARKDOWN
      #{section_heading}

      Keystone Components is a ViewComponent gem. Use the helpers below in your ERB views.

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

    puts "Keystone Components API reference written to #{path}"
  end
end
