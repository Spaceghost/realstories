class Chapter < ActiveRecord::Base
  belongs_to :story
  has_many :pages
  attr_accessible :chapter_name
end
