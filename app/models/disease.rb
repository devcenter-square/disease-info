class Disease < ActiveRecord::Base
  validates_presence_of :name
  validates :data_source, inclusion: { in: %w[WHO ORPHANET], allow_nil: true }

  serialize :facts, type: Array
  serialize :symptoms, type: Array
  serialize :transmission, type: Array
  serialize :diagnosis, type: Array
  serialize :treatment, type: Array
  serialize :prevention, type: Array

  scope :active, -> { where(is_active: true) }
  scope :inactive, -> { where(is_active: false) }
  scope :by_source, ->(source) { where(data_source: source) }
end
