import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { Input } from "@ember/component";
import { fn } from "@ember/helper";
import { on } from "@ember/modifier";
import { action } from "@ember/object";
import didInsert from "@ember/render-modifiers/modifiers/did-insert";
import { htmlSafe } from "@ember/template";
import { TrackedArray } from "@ember-compat/tracked-built-ins";
import { eq } from "truth-helpers";
import AsyncContent from "discourse/components/async-content";
import DButton from "discourse/components/d-button";
import DropdownMenu from "discourse/components/dropdown-menu";
import TextField from "discourse/components/text-field";
import concatClass from "discourse/helpers/concat-class";
import icon from "discourse/helpers/d-icon";
import element from "discourse/helpers/element";
import { i18n } from "discourse-i18n";
import DMenu from "float-kit/components/d-menu";

class Skeleton extends Component {
  get width() {
    return htmlSafe(`width: ${Math.floor(Math.random() * 70) + 20}%`);
  }

  <template>
    <div class="d-multi-select__skeleton">
      <div class="d-multi-select__skeleton-checkbox" />
      <div class="d-multi-select__skeleton-text" style={{this.width}} />
    </div>
  </template>
}

export default class DMultiSelect extends Component {
  @tracked searchTerm = "";

  @tracked preselectedItem = null;

  @tracked selection = new TrackedArray(this.args.selection);

  @tracked results = null;

  get hasSelection() {
    return this.selection.length > 0;
  }

  get label() {
    return this.args.label ?? i18n("multi_select.label");
  }

  @action
  resultsChanged(results) {
    this.preselectedItem = null;
    this.results = results;
  }

  @action
  search(event) {
    this.searchTerm = event.target.value;
  }

  @action
  focus(input) {
    input.focus();
  }

  @action
  handleKeydown(event) {
    if (event.key === "Enter") {
      event.preventDefault();

      if (this.preselectedItem) {
        this.toggle(this.preselectedItem);
      }
    }

    if (event.key === "ArrowDown") {
      event.preventDefault();

      if (!this.results || this.results.length === 0) {
        return;
      }

      if (this.preselectedItem === null) {
        this.preselectedItem = this.results[0];
      } else {
        const currentIndex = this.results.findIndex((item) =>
          this.compare(item, this.preselectedItem)
        );

        if (currentIndex < this.results.length - 1) {
          this.preselectedItem = this.results[currentIndex + 1];
        }
      }
    }

    if (event.key === "ArrowUp") {
      event.preventDefault();

      if (!this.results || this.results.length === 0) {
        return;
      }

      if (this.preselectedItem === null) {
        this.preselectedItem = this.results[0];
      } else {
        const currentIndex = this.results.findIndex((item) =>
          this.compare(item, this.preselectedItem)
        );

        if (currentIndex > 0) {
          this.preselectedItem = this.results[currentIndex - 1];
        }
      }
    }
  }

  @action
  remove(selectedItem, event) {
    event.stopPropagation();

    this.selection = new TrackedArray(
      this.selection.filter((item) => !this.compare(item, selectedItem))
    );
  }

  @action
  isSelected(result) {
    return this.selection.filter((item) => this.compare(item, result)).length;
  }

  @action
  toggle(result, event) {
    event?.stopPropagation();

    if (this.isSelected(result)) {
      this.selection = new TrackedArray(
        this.selection.filter((item) => !this.compare(item, result))
      );
    } else {
      this.selection.push(result);
    }

    this.args.onChange?.(this.selection);
  }

  @action
  compare(a, b) {
    return this.args.compareFn?.(a, b) ?? a.id === b.id;
  }

  <template>
    <DMenu
      @identifier="d-multi-select"
      @triggerComponent={{element "div"}}
      @triggerClass={{concatClass (if this.hasSelection "--has-selection")}}
      ...attributes
    >
      <:trigger>
        {{#if this.selection}}
          <div class="d-multi-select-trigger__selection">
            {{#each this.selection as |item|}}
              <button
                class="d-multi-select-trigger__selected-item"
                {{on "click" (fn this.remove item)}}
              >
                <span class="d-multi-select-trigger__selection-label">{{yield
                    item
                    to="selection"
                  }}</span>
                {{icon
                  "xmark"
                  class="d-multi-select-trigger__remove-selection-icon"
                }}
              </button>
            {{/each}}
          </div>
        {{else}}
          <span class="d-multi-select-trigger__label">{{this.label}}</span>
        {{/if}}

        <DButton
          @icon="angle-down"
          class="d-multi-select-trigger__expand-btn btn-transparent"
          @action={{@componentArgs.show}}
        />
      </:trigger>
      <:content>
        <DropdownMenu class="d-multi-select__content" as |menu|>
          <menu.item class="d-multi-select__search-container">
            {{icon "magnifying-glass"}}
            <TextField
              class="d-multi-select__search-input"
              autocomplete="off"
              @placeholder={{i18n "multi_select.search"}}
              @type="search"
              {{on "input" this.search}}
              {{on "keydown" this.handleKeydown}}
              {{didInsert this.focus}}
              @value={{readonly this.searchTerm}}
            />
          </menu.item>

          <menu.divider />

          <AsyncContent
            @asyncData={{fn @loadFn this.searchTerm}}
            @debounce={{true}}
            @context={{this.searchTerm}}
          >
            <:empty><div class="d-multi-select__search-no-results">{{i18n
                  "multi_select.no_results"
                }}</div></:empty>
            <:loading>
              <div class="d-multi-select__skeletons">
                <Skeleton />
                <Skeleton />
                <Skeleton />
                <Skeleton />
                <Skeleton />
              </div>
            </:loading>
            <:content as |results|>
              {{this.resultsChanged results}}

              <div class="d-multi-select__search-results">
                {{#each results as |result|}}
                  <menu.item
                    class={{concatClass
                      "d-multi-select__result"
                      (if (eq result this.preselectedItem) "--preselected" "")
                    }}
                    {{on "mouseenter" (fn (mut this.preselectedItem) result)}}
                    {{on "click" (fn this.toggle result)}}
                  >
                    <Input
                      @type="checkbox"
                      @checked={{this.isSelected result}}
                      class="d-multi-select__result-checkbox"
                      {{on "click" (fn this.toggle result)}}
                    />

                    <span class="d-multi-select__result-label">{{yield
                        result
                        to="result"
                      }}</span>
                  </menu.item>
                {{/each}}
              </div>
            </:content>
          </AsyncContent>
        </DropdownMenu>
      </:content>
    </DMenu>
  </template>
}
