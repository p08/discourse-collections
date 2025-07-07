class DiscourseCollection::Collection < ActiveRecord::Base
  self.table_name = 'discourse_collections'
  belongs_to :collectable, polymorphic: true
end
