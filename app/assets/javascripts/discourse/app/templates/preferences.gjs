import { hash } from "@ember/helper";
import RouteTemplate from 'ember-route-template';
import DNavigationItem from "discourse/components/d-navigation-item";
import HorizontalOverflowNav from "discourse/components/horizontal-overflow-nav";
import PluginOutlet from "discourse/components/plugin-outlet";
import bodyClass from "discourse/helpers/body-class";
import dIcon from "discourse/helpers/d-icon";
import iN from "discourse/helpers/i18n";
export default RouteTemplate(<template>{{bodyClass "user-preferences-page"}}

<div class="user-navigation user-navigation-secondary">
  <HorizontalOverflowNav @ariaLabel="User secondary - preferences">
    <DNavigationItem @route="preferences.account" @ariaCurrentContext="subNav" class="user-nav__preferences-account">
      {{dIcon "user"}}
      <span>{{iN "user.preferences_nav.account"}}</span>
    </DNavigationItem>

    <DNavigationItem @route="preferences.security" @ariaCurrentContext="subNav" class="user-nav__preferences-security">
      {{dIcon "lock"}}
      <span>{{iN "user.preferences_nav.security"}}</span>
    </DNavigationItem>

    <DNavigationItem @route="preferences.profile" @ariaCurrentContext="subNav" class="user-nav__preferences-profile">
      {{dIcon "user"}}
      <span>{{iN "user.preferences_nav.profile"}}</span>
    </DNavigationItem>

    <DNavigationItem @route="preferences.emails" @ariaCurrentContext="subNav" class="user-nav__preferences-emails">
      {{dIcon "envelope"}}
      <span>{{iN "user.preferences_nav.emails"}}</span>
    </DNavigationItem>

    <DNavigationItem @route="preferences.notifications" @ariaCurrentContext="subNav" class="user-nav__preferences-notifications">
      {{dIcon "bell"}}
      <span>{{iN "user.preferences_nav.notifications"}}</span>
    </DNavigationItem>

    {{#if @controller.model.can_change_tracking_preferences}}
      <DNavigationItem @route="preferences.tracking" @ariaCurrentContext="subNav" class="user-nav__preferences-tracking">
        {{dIcon "plus"}}
        <span>{{iN "user.preferences_nav.tracking"}}</span>
      </DNavigationItem>
    {{/if}}

    <DNavigationItem @route="preferences.users" @ariaCurrentContext="subNav" class="user-nav__preferences-users">
      {{dIcon "users"}}
      <span>{{iN "user.preferences_nav.users"}}</span>
    </DNavigationItem>

    <DNavigationItem @route="preferences.interface" @ariaCurrentContext="subNav" class="user-nav__preferences-interface">
      {{dIcon "desktop"}}
      <span>{{iN "user.preferences_nav.interface"}}</span>
    </DNavigationItem>

    <DNavigationItem @route="preferences.navigation-menu" @ariaCurrentContext="subNav" class="user-nav__preferences-navigation-menu">
      {{dIcon "bars"}}
      <span>{{iN "user.preferences_nav.navigation_menu"}}</span>
    </DNavigationItem>

    <PluginOutlet @name="user-preferences-nav-under-interface" @connectorTagName="div" @outletArgs={{hash model=@controller.model}} />
    <PluginOutlet @name="user-preferences-nav" @connectorTagName="li" @outletArgs={{hash model=@controller.model}} />
  </HorizontalOverflowNav>
</div>

<section class="user-content user-preferences" id="user-content">
  <span>
    <PluginOutlet @name="above-user-preferences" @connectorTagName="div" @outletArgs={{hash model=@controller.model}} />
  </span>

  <form class="form-vertical">
    {{outlet}}
  </form>
</section></template>);