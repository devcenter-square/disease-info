class ConvertDiseaseFieldsToArrays < ActiveRecord::Migration[7.1]
  FIELDS = %i[symptoms transmission diagnosis treatment prevention].freeze

  def up
    Disease.find_each do |disease|
      updates = {}
      FIELDS.each do |field|
        value = disease.read_attribute_before_type_cast(field)
        next if value.blank? || value.start_with?("---")

        updates[field] = [value]
      end
      disease.update_columns(updates) if updates.any?
    end
  end

  def down
    Disease.find_each do |disease|
      updates = {}
      FIELDS.each do |field|
        value = disease.send(field)
        next unless value.is_a?(Array)

        updates[field] = value.join("\n\n")
      end
      disease.update_columns(updates) if updates.any?
    end
  end
end
