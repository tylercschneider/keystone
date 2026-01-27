# frozen_string_literal: true

module KeystoneUiHelper
  def ui_card(**args)
    render Keystone::Ui::CardComponent.new(**args)
  end

  def ui_button(**args)
    render Keystone::Ui::ButtonComponent.new(**args)
  end

  def ui_data_table(**args)
    render Keystone::Ui::DataTableComponent.new(**args)
  end
end
