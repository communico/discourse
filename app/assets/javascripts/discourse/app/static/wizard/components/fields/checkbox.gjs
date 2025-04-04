import Component, { Input } from "@ember/component";
import { tagName } from "@ember-decorators/component";
import PluginOutlet from "discourse/components/plugin-outlet";
import { hash } from "@ember/helper";
import icon from "discourse/helpers/d-icon";

@tagName("")
export default class Checkbox extends Component {<template><label class="wizard-container__label">
  <PluginOutlet @name="wizard-checkbox" @outletArgs={{hash disabled=this.field.disabled}}>
    <Input @type="checkbox" disabled={{this.field.disabled}} class="wizard-container__checkbox" @checked={{this.field.value}} />
    <span class="wizard-container__checkbox-slider"></span>
    {{#if this.field.icon}}
      {{icon this.field.icon}}
    {{/if}}
    <span class="wizard-container__checkbox-label">
      {{this.field.placeholder}}
    </span>
  </PluginOutlet>

  <PluginOutlet @name="below-wizard-checkbox" @outletArgs={{hash disabled=this.field.disabled}} />
</label></template>}
