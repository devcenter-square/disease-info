class Disease < ActiveRecord::Base
  validates_presence_of :name

  serialize :facts, Array
end
