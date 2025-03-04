import { Input } from "@ember/component";
import { concat } from "@ember/helper";
import InputTip from "discourse/components/input-tip";
import htmlSafe from "discourse/helpers/html-safe";
import iN from "discourse/helpers/i18n";
import UserFieldBase from "./base";

export default class UserFieldText extends UserFieldBase {<template><div class="controls">
  <Input id={{concat "user-" this.elementId}} @value={{this.value}} maxlength={{this.site.user_field_max_length}} />
  <label class="control-label alt-placeholder" for={{concat "user-" this.elementId}}>
    {{this.field.name}}
    {{~#unless this.field.required}} {{iN "user_fields.optional"}}{{/unless~}}
  </label>
  <InputTip @validation={{this.validation}} class={{unless this.validation "hidden"}} />
  {{#unless this.validation}}
    <div class="instructions">{{htmlSafe this.field.description}}</div>
  {{/unless}}
</div></template>}
