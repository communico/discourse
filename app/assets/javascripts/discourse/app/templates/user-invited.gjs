import RouteTemplate from 'ember-route-template'
import bodyClass from "discourse/helpers/body-class";
import HorizontalOverflowNav from "discourse/components/horizontal-overflow-nav";
import NavItem from "discourse/components/nav-item";
export default RouteTemplate(<template>{{#if @controller.can_see_invite_details}}
  {{bodyClass "user-invites-page"}}

  <div class="user-navigation user-navigation-secondary">
    <HorizontalOverflowNav @ariaLabel="User secondary - invites">
      <NavItem @route="userInvited.show" @routeParam="pending" @i18nLabel={{@controller.pendingLabel}} />
      <NavItem @route="userInvited.show" @routeParam="expired" @i18nLabel={{@controller.expiredLabel}} />
      <NavItem @route="userInvited.show" @routeParam="redeemed" @i18nLabel={{@controller.redeemedLabel}} />
    </HorizontalOverflowNav>
  </div>
{{/if}}

{{outlet}}</template>)