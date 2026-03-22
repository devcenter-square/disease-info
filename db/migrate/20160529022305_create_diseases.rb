class CreateDiseases < ActiveRecord::Migration[4.2]
  def change
    create_table :diseases do |t|

      t.timestamps null: false
    end
  end
end
