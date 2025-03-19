import Component from "@ember/component";
import { tagName } from "@ember-decorators/component";
import { i18n } from "discourse/lib/computed";

@tagName("")
export default class UserNotificationScheduleDay extends Component {
  @i18n("day", "user.notification_schedule.%@") dayLabel;
}

<tr class="day {{this.dayLabel}}">
  <td class="day-label">{{this.dayLabel}}</td>
  <td class="starts-at">
    <ComboBox
      @valueProperty="value"
      @content={{this.startTimeOptions}}
      @value={{this.startTimeValue}}
      @onChange={{this.onChangeStartTime}}
    />
  </td>
  {{#if this.endTimeOptions}}
    <td class="to">{{i18n "user.notification_schedule.to"}}</td>
    <td class="ends-at">
      <ComboBox
        @valueProperty="value"
        @content={{this.endTimeOptions}}
        @value={{this.endTimeValue}}
        @onChange={{this.onChangeEndTime}}
      />
    </td>
  {{/if}}
</tr>