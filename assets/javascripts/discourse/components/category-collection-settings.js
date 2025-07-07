import Component from "@glimmer/component";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";
import { ajax } from "discourse/lib/ajax";
import { tracked } from "@glimmer/tracking";

export default class CategoryCollectionSettings extends Component {
  @service siteSettings;

  @tracked name = "";
  @tracked description = "";
  @tracked saving = false;

  constructor() {
    super(...arguments);
    const collection = this.args.category?.discourse_collection;
    if (collection) {
      this.name = collection.name;
      this.description = collection.description;
    }
  }

  @action
  async saveCollection() {
    this.saving = true;
    const categoryId = this.args.category.id;

    await ajax("/discourse-collections/collections", {
      type: "POST",
      data: {
        collection: {
          name: this.name,
          description: this.description,
          collectable_type: "Category",
          collectable_id: categoryId
        }
      }
    });

    this.saving = false;
  }
}
