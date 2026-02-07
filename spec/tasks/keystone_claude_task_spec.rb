# frozen_string_literal: true

require "fileutils"
require "rake"
require "tmpdir"

RSpec.describe "keystone:claude rake task" do
  let(:tmpdir) { Dir.mktmpdir }
  let(:claude_md_path) { File.join(tmpdir, "CLAUDE.md") }

  before(:all) do
    Rake.application = Rake::Application.new
    Rake.application.rake_require("keystone_components", [File.expand_path("../../lib/tasks", __dir__)])
  end

  before do
    allow(Dir).to receive(:pwd).and_return(tmpdir)
    Rake::Task["keystone:claude"].reenable
  end

  after do
    FileUtils.remove_entry(tmpdir)
  end

  it "creates CLAUDE.md when the file does not exist" do
    expect { Rake::Task["keystone:claude"].invoke }.to output(/written to/).to_stdout
    expect(File.exist?(claude_md_path)).to be true

    content = File.read(claude_md_path)
    expect(content).to start_with("## Keystone Components")
    expect(content).to include("ui_card")
    expect(content).to include("ui_button")
    expect(content).to include("ui_data_table")
  end

  it "documents all eight components" do
    Rake::Task["keystone:claude"].invoke

    content = File.read(claude_md_path)
    expect(content).to include("ui_page")
    expect(content).to include("ui_section")
    expect(content).to include("ui_grid")
    expect(content).to include("ui_panel")
    expect(content).to include("ui_card_link")
  end

  it "appends to existing CLAUDE.md without clobbering content" do
    File.write(claude_md_path, "# My App\n\nExisting content.\n")

    Rake::Task["keystone:claude"].invoke

    content = File.read(claude_md_path)
    expect(content).to start_with("# My App\n\nExisting content.")
    expect(content).to include("## Keystone Components")
    expect(content).to include("ui_data_table")
  end

  it "replaces the existing section on re-run (idempotent)" do
    File.write(claude_md_path, "# My App\n\nExisting content.\n")

    Rake::Task["keystone:claude"].invoke
    first_run = File.read(claude_md_path)

    Rake::Task["keystone:claude"].reenable
    Rake::Task["keystone:claude"].invoke
    second_run = File.read(claude_md_path)

    expect(second_run).to eq(first_run)
  end
end
