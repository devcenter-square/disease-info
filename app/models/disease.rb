class Disease < ActiveRecord::Base
  validates :name, presence: true
  validates :data_source, inclusion: { in: %w[WHO ORPHANET] }, allow_blank: true

  serialize :facts, type: Array, coder: YAML
  serialize :symptoms, type: Array, coder: YAML
  serialize :transmission, type: Array, coder: YAML
  serialize :diagnosis, type: Array, coder: YAML
  serialize :treatment, type: Array, coder: YAML
  serialize :prevention, type: Array, coder: YAML

  scope :active, -> { where(is_active: true) }
  scope :inactive, -> { where(is_active: false) }
  scope :by_source, ->(source) { where(data_source: source) }
end
