class AddPrevalenceAndDataSourceToDiseases < ActiveRecord::Migration[7.1]
  def change
    add_column :diseases, :prevalence, :decimal, precision: 10, scale: 6
    add_column :diseases, :data_source, :string

    reversible do |dir|
      dir.up do
        Disease.update_all(data_source: 'WHO')
      end
    end
  end
end
