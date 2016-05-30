class AddColumnsToDisease < ActiveRecord::Migration
  def change
    add_column :diseases, :name, :string
    add_column :diseases, :date_updated, :string
    add_column :diseases, :facts, :text
    add_column :diseases, :symptoms, :text
    add_column :diseases, :transmission, :text
    add_column :diseases, :diagnosis, :text
    add_column :diseases, :treatment, :text
    add_column :diseases, :prevention, :text
    add_column :diseases, :more, :text
  end
end
