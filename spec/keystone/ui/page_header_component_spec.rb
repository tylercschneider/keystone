# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::PageHeaderComponent do
  it "exposes title" do
    component = described_class.new(title: "Shopping Lists")

    expect(component.title).to eq("Shopping Lists")
  end

  it "exposes subtitle when provided" do
    component = described_class.new(title: "Lists", subtitle: "Manage your lists")

    expect(component.subtitle?).to be true
    expect(component.subtitle_text).to eq("Manage your lists")
  end

  it "returns false for subtitle? when not provided" do
    component = described_class.new(title: "Lists")

    expect(component.subtitle?).to be false
  end

  it "registers an action block via before_render" do
    component = described_class.new(title: "Lists")
    component.set_content_block do |header|
      header.action { "New List" }
    end

    expect(component.action?).to be false
    component.before_render
    expect(component.action?).to be true
  end
end
