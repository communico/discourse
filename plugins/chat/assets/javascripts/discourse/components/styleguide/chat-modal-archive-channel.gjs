import Component from "@glimmer/component";
import { action } from "@ember/object";
import { getOwner } from "@ember/owner";
import { service } from "@ember/service";
import DButton from "discourse/components/d-button";
import ChatModalArchiveChannel from "discourse/plugins/chat/discourse/components/chat/modal/archive-channel";
import ChatFabricators from "discourse/plugins/chat/discourse/lib/fabricators";
import Row from "discourse/plugins/styleguide/discourse/components/styleguide/controls/row";
import StyleguideExample from "discourse/plugins/styleguide/discourse/components/styleguide-example";

export default class ChatStyleguideChatModalArchiveChannel extends Component {
  @service modal;

  channel = new ChatFabricators(getOwner(this)).channel();

  @action
  openModal() {
    return this.modal.show(ChatModalArchiveChannel, {
      model: {
        channel: this.channel,
      },
    });
  }

  <template>
    <StyleguideExample @title="<Chat::Modal::ArchiveChannel>">
      <Row>
        <DButton @translatedLabel="Open modal" @action={{this.openModal}} />
      </Row>
    </StyleguideExample>
  </template>
}
