import StyleguideExample from "discourse/plugins/styleguide/discourse/components/styleguide-example";
import BreadCrumbs from "discourse/components/bread-crumbs";
const BreadCrumbs0 = <template><StyleguideExample @title="category-breadcrumbs">
  <BreadCrumbs @categories={{@dummy.categories}} @showTags={{false}} />
</StyleguideExample>

{{#if @siteSettings.tagging_enabled}}
  <StyleguideExample @title="category-breadcrumbs - tags">
    <BreadCrumbs @categories={{@dummy.categories}} @showTags={{true}} />
  </StyleguideExample>
{{/if}}</template>;
export default BreadCrumbs0;