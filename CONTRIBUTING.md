# Contributing

Thanks for your interest in contributing to Keystone Components!

## Getting Started

1. Fork and clone the repo
2. Run `bundle install`
3. Run `bundle exec rspec` to make sure tests pass

## Development

### Running Tests

```bash
bundle exec rspec                                          # All tests
bundle exec rspec spec/keystone/ui/button_component_spec.rb  # Single file
```

Tests run without a full Rails environment — the spec helper stubs `ViewComponent::Base`.

### TDD Workflow

We follow a strict TDD cycle:

1. Write one failing test
2. Run it — confirm it fails
3. Write minimal code to pass
4. Run it — confirm it passes
5. Run the full suite — catch regressions
6. Commit (usually 2 files: test + implementation)

### Branch Workflow

1. Create a branch from `main`
2. Make your changes following the TDD cycle
3. Push and open a pull request
4. PRs are reviewed before merging

### Conventions

- Components live under `Keystone::Ui` namespace in `app/components/keystone/ui/`
- Helpers in `app/helpers/keystone_ui_helper.rb` are thin render wrappers with no logic
- All Tailwind classes must be **complete static strings** (no interpolation) so the JIT scanner can detect them
- Use frozen constant hashes for class mappings (see `GridComponent::COL_CLASSES`)

## Reporting Issues

Open an issue on GitHub with:
- What you expected to happen
- What actually happened
- Steps to reproduce
- Ruby and Rails versions
