import { Input } from "@ember/component";
import { htmlSafe } from "@ember/template";
import icon from "discourse/helpers/d-icon";
import noop from "discourse/helpers/noop";
import { on } from "@ember/modifier";

const Input0 = <template>
  <div class="control-group form-template-field" data-field-type="input">
    {{#if @attributes.label}}
      <label class="form-template-field__label">
        {{@attributes.label}}
        {{#if @validations.required}}
          {{icon "asterisk" class="form-template-field__required-indicator"}}
        {{/if}}
      </label>
    {{/if}}

    {{#if @attributes.description}}
      <span class="form-template-field__description">
        {{htmlSafe @attributes.description}}
      </span>
    {{/if}}

    <Input
      name={{@id}}
      class="form-template-field__input"
      @value={{@value}}
      @type={{if @validations.type @validations.type "text"}}
      placeholder={{@attributes.placeholder}}
      required={{if @validations.required "required" ""}}
      pattern={{@validations.pattern}}
      minlength={{@validations.minimum}}
      maxlength={{@validations.maximum}}
      disabled={{@attributes.disabled}}
      {{on "input" (if @onChange @onChange (noop))}}
    />
  </div>
</template>;
export default Input0;
