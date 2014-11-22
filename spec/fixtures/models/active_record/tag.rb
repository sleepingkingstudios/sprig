require 'active_record'

class Tag < ActiveRecord::Base
  validates :name, :presence => true
end
