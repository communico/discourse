import Component from "@glimmer/component";
import { action } from "@ember/object";
import { getOwner } from "@ember/owner";
import { service } from "@ember/service";
import DButton from "discourse/components/d-button";
import ChatModalThreadSettings from "discourse/plugins/chat/discourse/components/chat/modal/thread-settings";
import ChatFabricators from "discourse/plugins/chat/discourse/lib/fabricators";
import Row from "discourse/plugins/styleguide/discourse/components/styleguide/controls/row";
import StyleguideExample from "discourse/plugins/styleguide/discourse/components/styleguide-example";

export default class ChatStyleguideChatModalThreadSettings extends Component {
  @service modal;

  @action
  openModal() {
    return this.modal.show(ChatModalThreadSettings, {
      model: new ChatFabricators(getOwner(this)).thread(),
    });
  }

<template><StyleguideExample @title="<Chat::Modal::ThreadSettings>">
  <Row>
    <DButton @translatedLabel="Open modal" @action={{this.openModal}} />
  </Row>
</StyleguideExample></template>}
