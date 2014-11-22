require 'active_record'

class Comment < ActiveRecord::Base
  belongs_to :post

  validates :post, :presence => true
end
