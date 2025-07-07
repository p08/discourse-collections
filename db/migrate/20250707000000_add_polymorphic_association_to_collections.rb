class AddPolymorphicAssociationToCollections < ActiveRecord::Migration[6.0]
  def change
    create_table :discourse_collections do |t|
      t.string :name
      t.text :description
      t.integer :collectable_id, null: false
      t.string :collectable_type, null: false
      t.timestamps
    end

    add_index :discourse_collections, [:collectable_type, :collectable_id]
  end
end
