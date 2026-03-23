class ConvertDiseaseFieldsToArrays < ActiveRecord::Migration[7.1]
  FIELDS = %w[symptoms transmission diagnosis treatment prevention].freeze

  def up
    rows = execute("SELECT id, #{FIELDS.join(', ')} FROM diseases")
    rows.each do |row|
      sets = []
      FIELDS.each do |field|
        value = row[field]
        next if value.blank? || value.start_with?("---")

        yaml = YAML.dump([value])
        sets << "#{field} = #{connection.quote(yaml)}"
      end
      execute("UPDATE diseases SET #{sets.join(', ')} WHERE id = #{row['id']}") if sets.any?
    end
  end

  def down
    rows = execute("SELECT id, #{FIELDS.join(', ')} FROM diseases")
    rows.each do |row|
      sets = []
      FIELDS.each do |field|
        value = row[field]
        next if value.blank?

        parsed = begin
          YAML.safe_load(value, permitted_classes: [Symbol])
        rescue StandardError
          nil
        end
        next unless parsed.is_a?(Array)

        sets << "#{field} = #{connection.quote(parsed.join("\n\n"))}"
      end
      execute("UPDATE diseases SET #{sets.join(', ')} WHERE id = #{row['id']}") if sets.any?
    end
  end
end
