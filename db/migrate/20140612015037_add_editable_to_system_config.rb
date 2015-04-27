class AddEditableToSystemConfig < ActiveRecord::Migration
  def change
    add_column :system_configs, :editable, :boolean, :default => true
  end
end
