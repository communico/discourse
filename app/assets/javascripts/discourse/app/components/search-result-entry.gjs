import Component from "@ember/component";
import { action } from "@ember/object";
import { attributeBindings, classNameBindings, classNames, tagName } from "@ember-decorators/component";
import { wantsNewWindow } from "discourse/lib/intercept-click";
import { logSearchLinkClick } from "discourse/lib/search";
import PluginOutlet from "discourse/components/plugin-outlet";
import { hash, fn } from "@ember/helper";
import avatar from "discourse/helpers/avatar";
import TrackSelected from "discourse/components/track-selected";
import { on } from "@ember/modifier";
import raw from "discourse/helpers/raw";
import htmlSafe from "discourse/helpers/html-safe";
import HighlightSearch from "discourse/components/highlight-search";
import categoryLink from "discourse/helpers/category-link";
import discourseTags from "discourse/helpers/discourse-tags";
import formatDate from "discourse/helpers/format-date";
import icon from "discourse/helpers/d-icon";

@tagName("div")
@classNames("fps-result")
@classNameBindings("bulkSelectEnabled")
@attributeBindings("role")
export default class SearchResultEntry extends Component {
  role = "listitem";

  @action
  logClick(topicId, event) {
    // Avoid click logging when any modifier keys are pressed.
    if (wantsNewWindow(event)) {
      return;
    }

    if (this.searchLogId && topicId) {
      logSearchLinkClick({
        searchLogId: this.searchLogId,
        searchResultId: topicId,
        searchResultType: "topic",
      });
    }
  }
<template><PluginOutlet @name="search-results-topic-avatar-wrapper" @outletArgs={{hash post=this.post}}>
  <div class="author">
    <a href={{this.post.userPath}} data-user-card={{this.post.username}}>
      {{avatar this.post imageSize="large"}}
    </a>
  </div>

</PluginOutlet>

<div class="fps-topic" data-topic-id={{this.post.topic.id}}>
  <div class="topic">

    {{#if this.bulkSelectEnabled}}
      <TrackSelected @selectedList={{this.selected}} @selectedId={{this.post.topic}} class="bulk-select" />
    {{/if}}

    <a href={{this.post.url}} {{on "click" (fn this.logClick this.post.topic_id)}} class="search-link{{if this.post.topic.visited " visited"}}" role="heading" aria-level="2">
      {{raw "topic-status" topic=this.post.topic showPrivateMessageIcon=true}}
      <span class="topic-title">
        {{#if this.post.useTopicTitleHeadline}}
          {{htmlSafe this.post.topicTitleHeadline}}
        {{else}}
          <HighlightSearch @highlight={{this.highlightQuery}}>
            {{htmlSafe this.post.topic.fancyTitle}}
          </HighlightSearch>
        {{/if}}
      </span>
      <PluginOutlet @name="search-results-topic-title-suffix" @outletArgs={{hash topic=this.post.topic}} />
    </a>

    <div class="search-category">
      {{#if this.post.topic.category.parentCategory}}
        {{categoryLink this.post.topic.category.parentCategory}}
      {{/if}}
      {{categoryLink this.post.topic.category hideParent=true}}
      {{#if this.post.topic}}
        {{discourseTags this.post.topic}}
      {{/if}}
      <span>
        <PluginOutlet @name="full-page-search-category" @connectorTagName="div" @outletArgs={{hash post=this.post}} />
      </span>
    </div>
  </div>

  <PluginOutlet @name="search-result-entry-blurb-wrapper" @outletArgs={{hash post=this.post logClick=this.logClick}}>
    <div class="blurb container">
      <span class="date">
        {{formatDate this.post.created_at format="tiny"}}
        {{#if this.post.blurb}}
          <span class="separator">-</span>
        {{/if}}
      </span>

      {{#if this.post.blurb}}
        {{#if this.siteSettings.use_pg_headlines_for_excerpt}}
          {{htmlSafe this.post.blurb}}
        {{else}}
          <HighlightSearch @highlight={{this.highlightQuery}}>
            {{htmlSafe this.post.blurb}}
          </HighlightSearch>
        {{/if}}
      {{/if}}
    </div>
  </PluginOutlet>

  <PluginOutlet @name="search-result-entry-stats-wrapper" @outletArgs={{hash post=this.post}}>
    {{#if this.showLikeCount}}
      {{#if this.post.like_count}}
        <span class="like-count">
          <span class="value">{{this.post.like_count}}</span>
          {{icon "heart"}}
        </span>
      {{/if}}
    {{/if}}
  </PluginOutlet>
</div>

<PluginOutlet @name="after-search-result-entry" /></template>}
