import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";

export default class ChangeTags extends Component {
  @tracked tags = [];
}

<p>{{i18n "topics.bulk.choose_new_tags"}}</p>

<p><TagChooser @tags={{this.tags}} @categoryId={{@categoryId}} /></p>

<DButton
  @action={{fn @performAndRefresh (hash type="change_tags" tags=this.tags)}}
  @disabled={{not this.tags}}
  @label="topics.bulk.change_tags"
/>