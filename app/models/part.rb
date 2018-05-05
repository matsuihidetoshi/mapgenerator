class Part < ApplicationRecord
  belongs_to :user
  
  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 100 }
  validates :content, presence: true, length: { maximum: 255 }
  
  has_many :relationships, dependent: :destroy
  has_many :relatings, through: :relationships, source: :relate
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'relate_id', dependent: :destroy
  has_many :related, through: :reverses_of_relationship, source: :part
  
  def relate(other_part)
    unless self == other_part
      self.relationships.find_or_create_by(relate_id: other_part.id)
    end
  end
  
  def unrelate(other_part)
    relationship = self.relationships.find_by(relate_id: other_part.id)
    relationship.destroy if relationship
  end
  
  def retating?(other_part)
    self.relating.include?(other_part)
  end
  
end
