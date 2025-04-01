import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { getOwner } from "@ember/owner";
import { next } from "@ember/runloop";
import { service } from "@ember/service";
import Item from "discourse/plugins/chat/discourse/components/chat/thread-list/item";
import ChatFabricators from "discourse/plugins/chat/discourse/lib/fabricators";
import Component0 from "discourse/plugins/styleguide/discourse/components/styleguide/component";
import StyleguideExample from "discourse/plugins/styleguide/discourse/components/styleguide-example";

export default class ChatStyleguideChatThreadListItem extends Component {
  @service currentUser;

  @tracked thread;

  constructor() {
    super(...arguments);

    next(() => {
      this.thread = new ChatFabricators(getOwner(this)).thread();
    });
  }

<template><StyleguideExample @title="<Chat::ThreadList::Item>">
  <Component0>
    {{#if this.thread}}
      <Item @thread={{this.thread}} />
    {{/if}}
  </Component0>
</StyleguideExample></template>}
