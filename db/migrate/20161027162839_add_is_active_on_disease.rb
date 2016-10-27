class AddIsActiveOnDisease < ActiveRecord::Migration
  def change
    add_column :diseases, :is_active, :boolean, default: true
  end
end
