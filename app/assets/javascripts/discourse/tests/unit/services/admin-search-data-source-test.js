import { getOwner } from "@ember/owner";
import { setupTest } from "ember-qunit";
import { module, test } from "qunit";
import sinon from "sinon";
import PreloadStore from "discourse/lib/preload-store";
import { ADMIN_NAV_MAP } from "discourse/lib/sidebar/admin-nav-map";
import { humanizedSettingName } from "discourse/lib/site-settings-utils";
import { i18n } from "discourse-i18n";
import {
  PageLinkFormatter,
  SettingLinkFormatter,
} from "admin/services/admin-search-data-source";

// NOTE: This test relies on `/admin/search/all.json` from admin-search-fixtures.js

function fabricateVisiblePlugins() {
  return [
    {
      admin_route: {
        auto_generated: false,
        full_location: "adminPlugins.show",
        label: "chat.admin.title",
        location: "chat",
        use_new_show_route: true,
      },
      description:
        "Adds chat functionality to your site so it can natively support both long-form and short-form communication needs of your online community",
      enabled: true,
      name: "chat",
      humanized_name: "Chat",
    },
    {
      name: "discourse-new-features-feeds",
      humanized_name: "New features feeds",
      admin_route: {
        location: "discourse-new-features-feeds",
        label: "new_feature_feeds.sidebar_plugin_name",
        use_new_show_route: true,
        auto_generated: false,
        full_location: "adminPlugins.show",
      },
      enabled: true,
      description:
        "Create feeds for new feature notices consumed by other Discourse instances.",
    },
    {
      name: "discourse-calendar",
      humanized_name: "Calendar",
      enabled: false,
      description:
        "Adds the ability to create a dynamic calendar with events in a topic.",
    },
    {
      name: "badplugin",
      humanized_name: "Badplugin",
      admin_route: {
        location: "blahblahnogood",
        label: "badplugin.title",
        use_new_show_route: true,
        auto_generated: true,
        full_location: "somemesseduproute",
      },
      enabled: true,
      description: "Does things",
    },
  ];
}

module("Unit | Service | AdminSearchDataSource", function (hooks) {
  setupTest(hooks);

  hooks.beforeEach(function () {
    this.subject = getOwner(this).lookup("service:admin-search-data-source");
  });

  test("buildMap - is a noop if already cached", async function (assert) {
    await this.subject.buildMap();
    sinon.stub(ADMIN_NAV_MAP, "forEach");
    await this.subject.buildMap();
    assert.false(ADMIN_NAV_MAP.forEach.called);
  });

  test("buildMap - makes a key/value object of preloaded plugins, excluding disabled and invalid ones", async function (assert) {
    PreloadStore.store("visiblePlugins", fabricateVisiblePlugins());
    await this.subject.buildMap();
    assert.deepEqual(Object.keys(this.subject.plugins), [
      "chat",
      "discourse-new-features-feeds",
    ]);
    assert.deepEqual(
      this.subject.plugins["chat"],
      fabricateVisiblePlugins()[0]
    );
  });

  test("buildMap - uses ADMIN_NAV_MAP to build up a list of page links including sub-pages", async function (assert) {
    await this.subject.buildMap();

    assert.true(this.subject.pageDataSourceItems.length > ADMIN_NAV_MAP.length);

    assert.deepEqual(this.subject.pageDataSourceItems[0], {
      label: "Dashboard",
      url: "/admin",
      keywords:
        " /admin dashboard the dashboard provides a snapshot of your community’s health, including traffic, user activity, and other key metrics",
      type: "page",
      icon: "house",
      description:
        "The dashboard provides a snapshot of your community’s health, including traffic, user activity, and other key metrics",
    });

    assert.notStrictEqual(
      this.subject.pageDataSourceItems.find(
        (page) => page.url === "/admin/backups/logs"
      ),
      null
    );
  });

  test("search - returns empty array if the search term is too small", async function (assert) {
    await this.subject.buildMap();
    assert.deepEqual(this.subject.search("a"), []);
  });

  test("search - limits the returned types", async function (assert) {
    await this.subject.buildMap();
    let results = this.subject.search("anonymous");
    assert.deepEqual(results.length, 3);

    results = this.subject.search("anonymous", { types: ["report"] });
    assert.deepEqual(results.length, 1);
    assert.deepEqual(
      results[0].url,
      "/admin/reports/page_view_anon_browser_reqs"
    );
  });
});

module(
  "Unit | Service | AdminSearchDataSource | PageLinkFormatter",
  function (hooks) {
    setupTest(hooks);

    hooks.beforeEach(function () {
      this.router = getOwner(this).lookup("service:router");
    });

    test("url is correct based on href/route/route models", function (assert) {
      const navMapSection = {
        label: "admin.config_sections.account.title",
        name: "root",
      };
      let link = {
        route: "admin.dashboard.general",
      };
      let formatter = new PageLinkFormatter(this.router, navMapSection, link);
      assert.deepEqual(formatter.format().url, "/admin");

      link = {
        route: "adminConfig.flags.edit",
        routeModels: [{ flag_id: 1 }],
      };
      formatter = new PageLinkFormatter(this.router, navMapSection, link);
      assert.deepEqual(formatter.format().url, "/admin/config/flags/1");

      link = {
        href: "/admin/something",
      };
      formatter = new PageLinkFormatter(this.router, navMapSection, link);
      assert.deepEqual(formatter.format().url, "/admin/something");
    });

    test("label is correct based on section label, link label, and parent label", async function (assert) {
      const navMapSection = {
        label: "admin.config_sections.account.title",
        name: "root",
      };
      let link = {
        label: "admin.config.backups.title",
      };
      let formatter = new PageLinkFormatter(this.router, navMapSection, link);
      assert.deepEqual(
        formatter.format().label,
        i18n(navMapSection.label) + " > " + i18n(link.label),
        "link uses the section label and link label"
      );

      link = {
        label: "admin.config.backups.sub_pages.logs.title",
      };
      formatter = new PageLinkFormatter(
        this.router,
        navMapSection,
        link,
        i18n("admin.config.backups.title")
      );
      assert.deepEqual(
        formatter.format().label,
        i18n(navMapSection.label) +
          " > " +
          i18n("admin.config.backups.title") +
          " > " +
          i18n(link.label),
        "link uses the section label, parent label, and link label for sub-pages"
      );

      link = {
        text: "Already translated",
      };
      formatter = new PageLinkFormatter(this.router, navMapSection, link);
      assert.deepEqual(
        formatter.format().label,
        i18n(navMapSection.label) + " > " + "Already translated",
        "link uses the text property if available"
      );
    });

    test("keywords are correct using the link keywords, url, label, and description", async function (assert) {
      const navMapSection = {
        label: "admin.config_sections.account.title",
        name: "root",
      };
      let link = {
        label: "admin.config.flags.title",
        description: "admin.config.flags.header_description",
        route: "admin.dashboard.general",
        keywords: "admin.config.flags.keywords",
      };

      let formatter = new PageLinkFormatter(this.router, navMapSection, link);
      assert.deepEqual(
        formatter.format().keywords,
        `flag review spam illegal /admin ${i18n("admin.config_sections.account.title").toLowerCase()} ${i18n("admin.config.flags.title").toLowerCase()} ${i18n("admin.config.flags.header_description").toLowerCase()}`
      );
    });
  }
);

module(
  "Unit | Service | AdminSearchDataSource | SettingLinkFormatter",
  function (hooks) {
    setupTest(hooks);

    hooks.beforeEach(function () {
      this.router = getOwner(this).lookup("service:router");
      this.plugins = { chat: fabricateVisiblePlugins()[0] };
    });

    test("label is correct for a setting that comes from a plugin", async function (assert) {
      let setting = {
        plugin: "chat",
        setting: "enable_chat",
      };
      let formatter = new SettingLinkFormatter(
        this.router,
        setting,
        this.plugins,
        {}
      );
      assert.deepEqual(
        formatter.format().label,
        i18n("chat.admin.title") +
          " > " +
          humanizedSettingName(setting.setting),
        "label uses the plugin admin route label and setting name"
      );
    });

    test("label is correct for a setting that has a primary area", async function (assert) {
      let setting = {
        setting: "enable_chat",
        primary_area: "about",
      };
      const settingPageMap = {
        categores: {},
        areas: { about: "/admin/plugins/chat/settings" },
      };
      let formatter = new SettingLinkFormatter(
        this.router,
        setting,
        this.plugins,
        settingPageMap
      );
      assert.deepEqual(
        formatter.format().label,
        i18n("admin.config.about.title") +
          " > " +
          humanizedSettingName(setting.setting),
        "label uses the primary area and setting name"
      );
    });

    test("label is correct for a setting that just belongs to a category", async function (assert) {
      let setting = {
        setting: "enable_chat",
        category: "required",
      };
      const settingPageMap = {
        categories: { required: "/admin/plugins/chat" },
        areas: {},
      };
      let formatter = new SettingLinkFormatter(
        this.router,
        setting,
        this.plugins,
        settingPageMap
      );
      assert.deepEqual(
        formatter.format().label,
        i18n("admin.site_settings.categories.required") +
          " > " +
          humanizedSettingName(setting.setting),
        "label uses the category and setting name"
      );
    });

    test("url is correct for a setting that belongs to a plugin", async function (assert) {
      let setting = {
        plugin: "chat",
        setting: "enable_chat",
      };
      let formatter = new SettingLinkFormatter(
        this.router,
        setting,
        this.plugins,
        {}
      );
      assert.deepEqual(
        formatter.format().url,
        "/admin/plugins/chat/settings?filter=enable_chat",
        "url uses the plugin admin route location and setting"
      );
    });

    test("url is correct for a setting that has a primary area", async function (assert) {
      let setting = {
        setting: "enable_chat",
        primary_area: "about",
      };
      const settingPageMap = {
        categores: {},
        areas: { about: "/admin/plugins/chat/settings" },
      };
      let formatter = new SettingLinkFormatter(
        this.router,
        setting,
        this.plugins,
        settingPageMap
      );
      assert.deepEqual(
        formatter.format().url,
        "/admin/plugins/chat/settings?filter=enable_chat",
        "url uses the primary area and setting"
      );
    });

    test("url is correct for a setting that only belongs to a category", async function (assert) {
      let setting = {
        setting: "enable_chat",
        category: "required",
      };
      const settingPageMap = {
        categories: { required: "/admin/plugins/chat" },
        areas: {},
      };
      let formatter = new SettingLinkFormatter(
        this.router,
        setting,
        this.plugins,
        settingPageMap
      );
      assert.deepEqual(
        formatter.format().url,
        "/admin/plugins/chat?filter=enable_chat",
        "url uses the category and setting"
      );
    });
  }
);
