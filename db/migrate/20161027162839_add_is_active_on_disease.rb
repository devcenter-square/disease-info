class AddIsActiveOnDisease < ActiveRecord::Migration[4.2]
  def change
    add_column :diseases, :is_active, :boolean, default: true
  end
end
