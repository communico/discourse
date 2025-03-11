import RouteTemplate from 'ember-route-template'
import i18n from "discourse/helpers/i18n";
import TagGroupsForm from "discourse/components/tag-groups-form";
export default RouteTemplate(<template><div class="tag-group-content">
  <h3>{{i18n "tagging.groups.edit_title"}}</h3>
  <TagGroupsForm @model={{@controller.model}} @onDestroy={{action "onDestroy"}} />
</div></template>)