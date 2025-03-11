import Component from "@ember/component";

// Exists so plugins can use it
import i18n from "discourse/helpers/i18n";
import { concat } from "@ember/helper";
import PluginOutlet from "discourse/components/plugin-outlet";
import LatestTopicListItem from "discourse/components/topic-list/latest-topic-list-item";
import eq from "truth-helpers/helpers/eq";
import getUrl from "discourse/helpers/get-url";
export default class CategoriesTopicList extends Component {<template><div role="heading" aria-level="2" class="table-heading">
  {{i18n (concat "filters." this.filter ".title")}}
  <PluginOutlet @name="categories-topics-table-heading" @connectorTagName="div" />
</div>

{{#if this.topics}}
  {{#each this.topics as |t|}}
    {{#if this.site.useGlimmerTopicList}}
      <LatestTopicListItem @topic={{t}} />
    {{else}}
      <LatestTopicListItem @topic={{t}} />
    {{/if}}
  {{/each}}

  <div class="more-topics">
    {{#if (eq this.siteSettings.desktop_category_page_style "categories_and_latest_topics_created_date")}}
      <a href={{getUrl (concat "/" this.filter "?order=created")}} class="btn btn-default pull-right">{{i18n "more"}}</a>
    {{else}}
      <a href={{getUrl (concat "/" this.filter)}} class="btn btn-default pull-right">{{i18n "more"}}</a>
    {{/if}}
  </div>
{{else}}
  <div class="no-topics">
    <h3>{{i18n (concat "topics.none." this.filter)}}</h3>
  </div>
{{/if}}</template>}
