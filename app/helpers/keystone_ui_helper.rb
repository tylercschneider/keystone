# frozen_string_literal: true

module KeystoneUiHelper
  def ui_card(**args)
    render Keystone::Ui::CardComponent.new(**args)
  end

  def ui_button(**args)
    render Keystone::Ui::ButtonComponent.new(**args)
  end

  def ui_data_table(**args, &block)
    render Keystone::Ui::DataTableComponent.new(**args), &block
  end

  def ui_page(**args, &block)
    render Keystone::Ui::PageComponent.new(**args), &block
  end

  def ui_section(**args, &block)
    render Keystone::Ui::SectionComponent.new(**args), &block
  end

  def ui_grid(**args, &block)
    render Keystone::Ui::GridComponent.new(**args), &block
  end

  def ui_panel(**args, &block)
    render Keystone::Ui::PanelComponent.new(**args), &block
  end

  def ui_card_link(**args, &block)
    render Keystone::Ui::CardLinkComponent.new(**args), &block
  end

  def ui_input(**args)
    render Keystone::Ui::InputComponent.new(**args)
  end

  def ui_textarea(**args)
    render Keystone::Ui::TextareaComponent.new(**args)
  end

  def ui_form_field(**args)
    render Keystone::Ui::FormFieldComponent.new(**args)
  end

  def ui_page_header(**args, &block)
    render Keystone::Ui::PageHeaderComponent.new(**args), &block
  end

  def ui_alert(**args)
    render Keystone::Ui::AlertComponent.new(**args)
  end

  def ui_form_page(**args)
    render Keystone::Ui::FormPageComponent.new(**args)
  end

  def ui_show_page(**args)
    render Keystone::Ui::ShowPageComponent.new(**args)
  end

  def ui_mobile_header(**args)
    render Keystone::Ui::MobileHeaderComponent.new(**args)
  end

  def ui_mobile_actions(**args, &block)
    render Keystone::Ui::MobileActionsComponent.new(**args), &block
  end
end
