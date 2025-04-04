import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import { HEADER_INDICATOR_PREFERENCE_ALL_NEW, HEADER_INDICATOR_PREFERENCE_DM_AND_MENTIONS, HEADER_INDICATOR_PREFERENCE_NEVER, HEADER_INDICATOR_PREFERENCE_ONLY_MENTIONS } from "discourse/plugins/chat/discourse/controllers/preferences-chat";
import StyleguideExample from "discourse/plugins/styleguide/discourse/components/styleguide-example";
import Component0 from "discourse/plugins/styleguide/discourse/components/styleguide/component";
import Icon from "discourse/plugins/chat/discourse/components/chat/header/icon";
import Controls from "discourse/plugins/styleguide/discourse/components/styleguide/controls";
import Row from "discourse/plugins/styleguide/discourse/components/styleguide/controls/row";
import DToggleSwitch from "discourse/components/d-toggle-switch";
import { on } from "@ember/modifier";
import ComboBox from "select-kit/components/combo-box";

export default class ChatStyleguideChatHeaderIcon extends Component {
  @tracked isActive = false;
  @tracked currentUserInDnD = false;
  @tracked urgentCount;
  @tracked unreadCount;
  @tracked indicatorPreference = HEADER_INDICATOR_PREFERENCE_ALL_NEW;

  get indicatorPreferences() {
    return [
      HEADER_INDICATOR_PREFERENCE_ALL_NEW,
      HEADER_INDICATOR_PREFERENCE_DM_AND_MENTIONS,
      HEADER_INDICATOR_PREFERENCE_ONLY_MENTIONS,
      HEADER_INDICATOR_PREFERENCE_NEVER,
    ];
  }

  @action
  toggleIsActive() {
    this.isActive = !this.isActive;
  }

  @action
  toggleCurrentUserInDnD() {
    this.currentUserInDnD = !this.currentUserInDnD;
  }

  @action
  updateUnreadCount(event) {
    this.unreadCount = event.target.value;
  }

  @action
  updateUrgentCount(event) {
    this.urgentCount = event.target.value;
  }

  @action
  updateIndicatorPreference(value) {
    this.indicatorPreference = value;
  }
<template><StyleguideExample @title="<Chat::Header::Icon>">
  <Component0>
    <header class="d-header" style="display: flex; align-items: center; justify-content: center;">
      <ul class="d-header-icons">
        <li class="header-dropdown-toggle chat-header-icon">
          <Icon @isActive={{this.isActive}} @currentUserInDnD={{this.currentUserInDnD}} @unreadCount={{this.unreadCount}} @urgentCount={{this.urgentCount}} @indicatorPreference={{this.indicatorPreference}} />
        </li>
      </ul>
    </header>
  </Component0>

  <Controls>
    <Row @name="isActive">
      <DToggleSwitch @state={{this.isActive}} {{on "click" this.toggleIsActive}} />
    </Row>
    <Row @name="currentUserInDnD">
      <DToggleSwitch @state={{this.currentUserInDnD}} {{on "click" this.toggleCurrentUserInDnD}} />
    </Row>
  </Controls>
  <Row @name="Unread count">
    <input type="number" {{on "input" this.updateUnreadCount}} value={{this.unreadCount}} />
  </Row>
  <Row @name="Urgent count">
    <input type="number" {{on "input" this.updateUrgentCount}} value={{this.urgentCount}} />
  </Row>
  <Row @name="Indicator preference">
    <ComboBox @value={{this.indicatorPreference}} @content={{this.indicatorPreferences}} @onChange={{this.updateIndicatorPreference}} @valueProperty={{null}} @nameProperty={{null}} />

  </Row>
</StyleguideExample></template>}
