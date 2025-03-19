import Component from "@ember/component";
import { action } from "@ember/object";
import { dependentKeyCompat } from "@ember/object/compat";
import { service } from "@ember/service";
import { classNames } from "@ember-decorators/component";
import { Promise } from "rsvp";
import BookmarkModal from "discourse/components/modal/bookmark";
import { ajax } from "discourse/lib/ajax";
import { BookmarkFormData } from "discourse/lib/bookmark-form-data";
import {
  openLinkInNewTab,
  shouldOpenInNewTab,
} from "discourse/lib/click-track";
import { i18n } from "discourse-i18n";

@classNames("bookmark-list-wrapper")
export default class BookmarkList extends Component {
  @service dialog;
  @service modal;

  get canDoBulkActions() {
    return this.bulkSelectHelper?.selected.length;
  }

  get selected() {
    return this.bulkSelectHelper?.selected;
  }

  get selectedCount() {
    return this.selected?.length || 0;
  }

  @action
  removeBookmark(bookmark) {
    return new Promise((resolve, reject) => {
      const deleteBookmark = () => {
        bookmark
          .destroy()
          .then(() => {
            this.appEvents.trigger(
              "bookmarks:changed",
              null,
              bookmark.attachedTo()
            );
            this._removeBookmarkFromList(bookmark);
            resolve(true);
          })
          .catch((error) => {
            reject(error);
          });
      };
      if (!bookmark.reminder_at) {
        return deleteBookmark();
      }
      this.dialog.deleteConfirm({
        message: i18n("bookmarks.confirm_delete"),
        didConfirm: () => deleteBookmark(),
        didCancel: () => resolve(false),
      });
    });
  }

  @action
  screenExcerptForExternalLink(event) {
    if (event?.target?.tagName === "A") {
      if (shouldOpenInNewTab(event.target.href)) {
        openLinkInNewTab(event, event.target);
      }
    }
  }

  @action
  editBookmark(bookmark) {
    this.modal.show(BookmarkModal, {
      model: {
        bookmark: new BookmarkFormData(bookmark),
        afterSave: (savedData) => {
          this.appEvents.trigger(
            "bookmarks:changed",
            savedData,
            bookmark.attachedTo()
          );
          this.reload();
        },
        afterDelete: () => {
          this.reload();
        },
      },
    });
  }

  @action
  clearBookmarkReminder(bookmark) {
    return ajax(`/bookmarks/${bookmark.id}`, {
      type: "PUT",
      data: { reminder_at: null },
    }).then(() => {
      bookmark.set("reminder_at", null);
    });
  }

  @action
  togglePinBookmark(bookmark) {
    bookmark.togglePin().then(this.reload);
  }

  @action
  toggleBulkSelect() {
    this.bulkSelectHelper?.toggleBulkSelect();
    this.rerender();
  }

  @action
  selectAll() {
    this.bulkSelectHelper.autoAddBookmarksToBulkSelect = true;
    document
      .querySelectorAll("input.bulk-select:not(:checked)")
      .forEach((el) => el.click());
  }

  @action
  clearAll() {
    this.bulkSelectHelper.autoAddBookmarksToBulkSelect = false;
    document
      .querySelectorAll("input.bulk-select:checked")
      .forEach((el) => el.click());
  }

  @dependentKeyCompat // for the classNameBindings
  get bulkSelectEnabled() {
    return this.bulkSelectHelper?.bulkSelectEnabled;
  }

  _removeBookmarkFromList(bookmark) {
    this.content.removeObject(bookmark);
  }

  _toggleSelection(target, bookmark, isSelectingRange) {
    const selected = this.selected;

    if (target.checked) {
      selected.addObject(bookmark);

      if (isSelectingRange) {
        const bulkSelects = Array.from(
            document.querySelectorAll("input.bulk-select")
          ),
          from = bulkSelects.indexOf(target),
          to = bulkSelects.findIndex((el) => el.id === this.lastChecked.id),
          start = Math.min(from, to),
          end = Math.max(from, to);

        bulkSelects
          .slice(start, end)
          .filter((el) => el.checked !== true)
          .forEach((checkbox) => {
            checkbox.click();
          });
      }
      this.set("lastChecked", target);
    } else {
      selected.removeObject(bookmark);
      this.set("lastChecked", null);
    }
  }

  click(e) {
    const onClick = (sel, callback) => {
      let target = e.target.closest(sel);

      if (target) {
        callback(target);
      }
    };

    onClick("input.bulk-select", () => {
      const target = e.target;
      const bookmarkId = target.dataset.id;
      const bookmark = this.content.find(
        (item) => item.id.toString() === bookmarkId
      );
      this._toggleSelection(target, bookmark, this.lastChecked && e.shiftKey);
    });
  }
}

<ConditionalLoadingSpinner @condition={{this.loading}}>
  <LoadMore
    @selector=".bookmark-list .bookmark-list-item"
    @action={{this.loadMore}}
  >
    <table class="topic-list bookmark-list">
      <thead class="topic-list-header">
        {{#if this.site.desktopView}}
          <PluginOutlet @name="bookmark-list-table-header">
            {{#if this.bulkSelectEnabled}}
              <th class="bulk-select topic-list-data">
                <FlatButton
                  @action={{this.toggleBulkSelect}}
                  @class="bulk-select"
                  @icon="list-check"
                  @title="bookmarks.bulk.toggle"
                />
              </th>
            {{/if}}
            <th class="topic-list-data">

              {{#if this.bulkSelectEnabled}}
                <span class="bulk-select-topics">
                  {{~#if this.canDoBulkActions}}
                    <div class="bulk-select-bookmarks-dropdown">
                      <span class="bulk-select-bookmark-dropdown__count">
                        {{i18n
                          "bookmarks.bulk.selected_count"
                          count=this.selectedCount
                        }}
                      </span>
                      <BulkSelectBookmarksDropdown
                        @bulkSelectHelper={{this.bulkSelectHelper}}
                      />
                    </div>

                  {{/if~}}
                  <DButton
                    @action={{this.selectAll}}
                    class="btn btn-default bulk-select-all"
                    @label="bookmarks.bulk.select_all"
                  />
                  <DButton
                    @action={{this.clearAll}}
                    class="btn btn-default bulk-clear-all"
                    @label="bookmarks.bulk.clear_all"
                  />
                </span>
              {{else}}
                <FlatButton
                  @action={{this.toggleBulkSelect}}
                  @class="bulk-select"
                  @icon="list-check"
                  @title="bookmarks.bulk.toggle"
                />
                {{i18n "topic.title"}}
              {{/if~}}
            </th>
            <th class="topic-list-data">&nbsp;</th>
            <th class="post-metadata topic-list-data">{{i18n
                "post.bookmarks.updated"
              }}</th>
            <th class="post-metadata topic-list-data">{{i18n "activity"}}</th>
            <th>&nbsp;</th>
          </PluginOutlet>
        {{/if}}
      </thead>
      <tbody class="topic-list-body">
        {{#each this.content as |bookmark|}}
          <tr class="topic-list-item bookmark-list-item">
            {{#if this.bulkSelectEnabled}}
              <td class="bulk-select bookmark-list-data">
                <label for="bulk-select-{{bookmark.id}}">
                  <input
                    type="checkbox"
                    class="bulk-select"
                    id="bulk-select-{{bookmark.id}}"
                    data-id={{bookmark.id}}
                  />
                </label>
              </td>
            {{/if}}
            <td class="main-link topic-list-data">
              <PluginOutlet
                @name="bookmark-list-before-link"
                @outletArgs={{hash bookmark=bookmark}}
              />

              <span class="link-top-line">
                <div class="bookmark-metadata">
                  {{#if bookmark.reminder_at}}
                    <span
                      class="bookmark-metadata-item bookmark-reminder
                        {{if
                          bookmark.reminderAtExpired
                          'bookmark-expired-reminder'
                        }}"
                    >
                      {{d-icon "far-clock"}}{{bookmark.formattedReminder}}
                    </span>
                  {{/if}}
                  {{#if bookmark.name}}
                    <span class="bookmark-metadata-item">
                      {{d-icon "circle-info"}}<span>{{bookmark.name}}</span>
                    </span>
                  {{/if}}
                </div>
                <div class="bookmark-status-with-link">
                  {{#if bookmark.pinned}}
                    {{d-icon "thumbtack" class="bookmark-pinned"}}
                  {{/if}}
                  {{#if bookmark.bookmarkableTopicAlike}}
                    <TopicStatus @topic={{bookmark.topicStatus}} />
                    {{topic-link bookmark.topicForList}}
                  {{else}}
                    <a
                      href={{bookmark.bookmarkable_url}}
                      role="heading"
                      aria-level="2"
                      class="title"
                      data-topic-id="${topic.id}"
                    >
                      {{bookmark.fancy_title}}
                    </a>
                  {{/if}}
                </div>
              </span>
              {{#if bookmark.bookmarkableTopicAlike}}
                <div class="link-bottom-line">
                  {{category-link bookmark.category}}
                  {{discourse-tags
                    bookmark
                    mode="list"
                    tagsForUser=this.tagsForUser
                  }}
                </div>
              {{/if}}
              {{#if
                (and
                  this.site.mobileView
                  bookmark.excerpt
                  bookmark.user.avatar_template
                )
              }}
                <a
                  href={{bookmark.bookmarkableUser.path}}
                  data-user-card={{bookmark.user.username}}
                  class="avatar"
                >
                  {{avatar
                    bookmark.bookmarkableUser
                    avatarTemplatePath="avatar_template"
                    usernamePath="username"
                    namePath="name"
                    imageSize="small"
                  }}
                </a>
              {{/if}}

              {{! template-lint-disable no-invalid-interactive }}
              <p
                class="post-excerpt"
                {{on "click" this.screenExcerptForExternalLink}}
              >{{html-safe bookmark.excerpt}}</p>
            </td>
            {{#if this.site.desktopView}}
              <td class="author-avatar topic-list-data">
                {{#if bookmark.user.avatar_template}}
                  <a
                    href={{bookmark.user.path}}
                    data-user-card={{bookmark.user.username}}
                    class="avatar"
                  >
                    {{avatar
                      bookmark.user
                      avatarTemplatePath="avatar_template"
                      usernamePath="username"
                      namePath="name"
                      imageSize="small"
                    }}
                  </a>
                {{/if}}
              </td>
              <td class="post-metadata topic-list-data updated-at">{{format-date
                  bookmark.updated_at
                  format="tiny"
                }}</td>
              {{raw
                "list/activity-column"
                topic=bookmark
                class="num post-metadata"
                tagName="td"
              }}
            {{/if}}
            <td class="topic-list-data">
              <BookmarkActionsDropdown
                @bookmark={{bookmark}}
                @removeBookmark={{action "removeBookmark"}}
                @editBookmark={{action "editBookmark"}}
                @clearBookmarkReminder={{action "clearBookmarkReminder"}}
                @togglePinBookmark={{action "togglePinBookmark"}}
              />
            </td>
          </tr>
        {{/each}}
      </tbody>
    </table>
    <ConditionalLoadingSpinner @condition={{this.loadingMore}} />
  </LoadMore>
</ConditionalLoadingSpinner>