class DiscourseCollection::CollectionSerializer < ApplicationSerializer
  attributes :id, :name, :description, :collectable_type, :collectable_id, :collectable_title

  def collectable_title
    object.collectable.try(:title) || object.collectable.try(:name)
  end
end
