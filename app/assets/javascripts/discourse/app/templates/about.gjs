import RouteTemplate from 'ember-route-template'
import PluginOutlet from "discourse/components/plugin-outlet";
import { hash } from "@ember/helper";
import bodyClass from "discourse/helpers/body-class";
import { LinkTo } from "@ember/routing";
import i18n from "discourse/helpers/i18n";
import AboutPage from "discourse/components/about-page";
export default RouteTemplate(<template><PluginOutlet @name="about-wrapper" @outletArgs={{hash model=@controller.model contactInfo=@controller.contactInfo faqOverridden=@controller.faqOverridden}}>
  {{bodyClass "about-page"}}

  <section>
    <div class="container">
      <div class="contents clearfix body-page">

        <ul class="nav-pills">
          <li class="nav-item-about"><LinkTo @route="about" class="active">{{i18n "about.simple_title"}}</LinkTo></li>
          {{#if @controller.faqOverridden}}
            <li class="nav-item-guidelines"><LinkTo @route="guidelines">{{i18n "guidelines"}}</LinkTo></li>
            <li class="nav-item-faq"><LinkTo @route="faq">{{i18n "faq"}}</LinkTo></li>
          {{else if @controller.renameFaqToGuidelines}}
            <li class="nav-item-guidelines"><LinkTo @route="guidelines">{{i18n "guidelines"}}</LinkTo></li>
          {{else}}
            <li class="nav-item-faq"><LinkTo @route="faq">{{i18n "faq"}}</LinkTo></li>
          {{/if}}
          {{#if @controller.site.tos_url}}
            <li class="nav-item-tos"><LinkTo @route="tos">{{i18n "tos"}}</LinkTo></li>
          {{/if}}
          {{#if @controller.site.privacy_policy_url}}
            <li class="nav-item-privacy"><LinkTo @route="privacy">{{i18n "privacy"}}</LinkTo></li>
          {{/if}}
        </ul>
        <AboutPage @model={{@controller.model}} />
      </div>
    </div>
  </section>
</PluginOutlet></template>)