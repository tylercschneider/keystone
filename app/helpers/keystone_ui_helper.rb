# frozen_string_literal: true

module KeystoneUiHelper
  def ui_card(**args)
    render Keystone::UI::CardComponent.new(**args)
  end

  def ui_button(**args)
    render Keystone::UI::ButtonComponent.new(**args)
  end

  def ui_data_table(**args)
    render Keystone::UI::DataTableComponent.new(**args)
  end
end
