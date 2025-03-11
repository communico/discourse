import RouteTemplate from 'ember-route-template'
import i18n from "discourse/helpers/i18n";
import categoryLink from "discourse/helpers/category-link";
export default RouteTemplate(<template><section class="user-content" id="user-content">
  {{#if @controller.model.permissions}}
    <label class="group-category-permissions-desc">
      {{i18n "groups.permissions.description"}}
    </label>
    <table class="group-category-permissions">
      <tbody>
        {{#each @controller.model.permissions as |permission|}}
          <tr>
            <td>{{categoryLink permission.category}}</td>
            <td>{{permission.description}}</td>
          </tr>
        {{/each}}
      </tbody>
    </table>
  {{else}}
    {{i18n "groups.permissions.none"}}
  {{/if}}
</section></template>)