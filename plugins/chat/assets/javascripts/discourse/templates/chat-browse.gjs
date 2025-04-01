import RouteTemplate from 'ember-route-template'
import Navbar from "discourse/plugins/chat/discourse/components/chat/navbar";
import i18n from "discourse/helpers/i18n";
export default RouteTemplate(<template><div class="c-routes --browse">
  <Navbar as |navbar|>
    <navbar.BackButton />
    <navbar.Title @title={{i18n "chat.browse.title"}} />

    <navbar.Actions as |a|>
      <a.NewChannelButton />
      <a.OpenDrawerButton />
    </navbar.Actions>
  </Navbar>

  {{outlet}}
</div></template>)