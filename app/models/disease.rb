class Disease < ActiveRecord::Base
  validates_presence_of :name

  serialize :facts, type: Array

  scope :active, -> { where(is_active: true) }
  scope :inactive, -> { where(is_active: false) }
end
