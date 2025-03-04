import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import ChooseTopic from "discourse/components/choose-topic";
import DButton from "discourse/components/d-button";
import DModal from "discourse/components/d-modal";
import iN from "discourse/helpers/i18n";
import { ajax } from "discourse/lib/ajax";
import { popupAjaxError } from "discourse/lib/ajax-error";

export default class FeatureTopicOnProfile extends Component {<template><DModal @closeModal={{@closeModal}} class="feature-topic-on-profile choose-topic-modal" id="choosing-topic" @title={{iN "user.feature_topic_on_profile.title"}}>
  <:body>
    <ChooseTopic @topicChangedCallback={{this.newTopicSelected}} @currentTopicId={{@model.user.featured_topic.id}} @loadOnInit={{true}} @additionalFilters="status:public" @label="user.feature_topic_on_profile.search_label" />
  </:body>
  <:footer>
    <DButton @action={{this.save}} class="btn-primary save-featured-topic-on-profile" @disabled={{this.noTopicSelected}} @label="user.feature_topic_on_profile.save" />
    <DButton @action={{@closeModal}} @label="cancel" class="btn-flat" />
  </:footer>
</DModal></template>
  @tracked newFeaturedTopic = null;
  @tracked saving = false;

  get noTopicSelected() {
    return !this.newFeaturedTopic;
  }

  @action
  async save() {
    try {
      this.saving = true;
      await ajax(`/u/${this.args.model.user.username}/feature-topic`, {
        type: "PUT",
        data: { topic_id: this.newFeaturedTopic.id },
      });

      this.args.model.setFeaturedTopic(this.newFeaturedTopic);
      this.args.closeModal();
    } catch (error) {
      popupAjaxError(error);
    } finally {
      this.saving = false;
    }
  }

  @action
  newTopicSelected(topic) {
    this.newFeaturedTopic = topic;
  }
}
