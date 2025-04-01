import { Textarea } from "@ember/component";
import { on } from "@ember/modifier";
import { htmlSafe } from "@ember/template";
import icon from "discourse/helpers/d-icon";
import noop from "discourse/helpers/noop";

const Textarea0 = <template>
  <div class="control-group form-template-field" data-field-type="textarea">
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

    <Textarea
      name={{@id}}
      @value={{@value}}
      class="form-template-field__textarea"
      placeholder={{@attributes.placeholder}}
      pattern={{@validations.pattern}}
      minlength={{@validations.minimum}}
      maxlength={{@validations.maximum}}
      required={{if @validations.required "required" ""}}
      {{on "input" (if @onChange @onChange (noop))}}
    />
  </div>
</template>;
export default Textarea0;
