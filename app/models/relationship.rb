class Relationship < ApplicationRecord
  belongs_to :part
  belongs_to :relate, class_name: 'Part'
  
  validates :part_id, presence: true
  validates :relate_id, presence: true
end
