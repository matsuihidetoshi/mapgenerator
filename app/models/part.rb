class Part < ApplicationRecord
  require 'json'

  belongs_to :user
  
  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 100 }
  validates :content, presence: true, length: { maximum: 255 }
  
  has_many :relationships, dependent: :destroy
  has_many :relatings, through: :relationships, source: :relate
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'relate_id', dependent: :destroy
  has_many :relateds, through: :reverses_of_relationship, source: :part
  
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
  
  def family
    array = []
    def gather(array, part)
      part.relatings.each do |child|
        array << child
        gather(array, child)
      end
    end
    gather(array, self)
    return array.sort
  end

  def family_hash
    hash = {name: self.title, title: self.content}
    def gather(part)
      array = []
      part.relatings.each do |child|
        child_hash = {name: child.title, title: child.content}
        child_hash.store(:children, gather(child)) if child.relatings.any?
        array << child_hash
      end
      return array
    end
    hash.store(:children, gather(self))
    return hash
  end

  def family_includes_self
    (family << self).sort
  end

  def family_to_options(includes_self=true)
    array = []
    if includes_self
      raw = family_includes_self
    else
      raw = family
    end
    raw.each do |f|
      array << [f.id.to_s + ":" + f.title, f.id]
    end
    return array
  end
end
