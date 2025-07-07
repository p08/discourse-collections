# frozen_string_literal: true

# name: discourse-collections
# about: Collections plugin for Discourse
# version: 0.2
# authors: Alteras1, ChatGPT
# url: https://github.com/yourusername/discourse-collections

enabled_site_setting :discourse_collections_enabled

after_initialize do
  module ::DiscourseCollection
    class Engine < ::Rails::Engine
      engine_name "discourse_collection"
      isolate_namespace DiscourseCollection
    end
  end

  require_dependency "application_controller"

  class DiscourseCollection::CollectionsController < ::ApplicationController
    requires_plugin ::DiscourseCollection

    before_action :ensure_logged_in

    def create
      collection = DiscourseCollection::Collection.find_or_initialize_by(
        collectable_type: params[:collection][:collectable_type],
        collectable_id: params[:collection][:collectable_id]
      )

      collection.assign_attributes(
        name: params[:collection][:name],
        description: params[:collection][:description]
      )

      collection.save!
      render_serialized(collection, DiscourseCollection::CollectionSerializer)
    end
  end

  DiscourseCollection::Engine.routes.draw do
    post "/collections" => "collections#create"
  end

  Discourse::Application.routes.append do
    mount ::DiscourseCollection::Engine, at: "/discourse-collections"
  end

  add_to_serializer(:basic_category, :discourse_collection) do
    collection = ::DiscourseCollection::Collection.find_by(
      collectable_type: 'Category',
      collectable_id: object.id
    )
    DiscourseCollection::CollectionSerializer.new(collection, root: false) if collection
  end
end
