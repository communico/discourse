// DO NOT EDIT THIS FILE!!!
// Update it by running `rake javascript:update_constants`

export const ADMIN_SEARCH_RESULT_TYPES = [
  "page",
  "setting",
  "theme",
  "component",
  "report",
];

export const SITE_SETTING_REQUIRES_CONFIRMATION_TYPES = {
  simple: "simple",
  user_option: "user_option",
};

export const API_KEY_SCOPE_MODES = ["global", "read_only", "granular"];

export const SYSTEM_FLAG_IDS = {
  like: 2,
  notify_user: 6,
  off_topic: 3,
  inappropriate: 4,
  spam: 8,
  illegal: 10,
  notify_moderators: 7,
};

export const REPORT_MODES = {
  table: "table",
  chart: "chart",
  stacked_chart: "stacked_chart",
  stacked_line_chart: "stacked_line_chart",
  radar: "radar",
  counters: "counters",
  inline_table: "inline_table",
  storage_stats: "storage_stats",
};

export const USER_FIELD_FLAGS = [
  "editable",
  "show_on_profile",
  "show_on_user_card",
  "searchable",
];

export const DEFAULT_USER_PREFERENCES = [
  "default_email_digest_frequency",
  "default_include_tl0_in_digests",
  "default_email_level",
  "default_email_messages_level",
  "default_email_mailing_list_mode",
  "default_email_mailing_list_mode_frequency",
  "default_email_previous_replies",
  "default_email_in_reply_to",
  "default_hide_profile",
  "default_hide_presence",
  "default_other_new_topic_duration_minutes",
  "default_other_auto_track_topics_after_msecs",
  "default_other_notification_level_when_replying",
  "default_other_external_links_in_new_tab",
  "default_other_enable_quoting",
  "default_other_enable_smart_lists",
  "default_other_enable_defer",
  "default_other_dynamic_favicon",
  "default_other_like_notification_frequency",
  "default_other_skip_new_user_tips",
  "default_topics_automatic_unpin",
  "default_categories_watching",
  "default_categories_tracking",
  "default_categories_muted",
  "default_categories_watching_first_post",
  "default_categories_normal",
  "default_tags_watching",
  "default_tags_tracking",
  "default_tags_muted",
  "default_tags_watching_first_post",
  "default_text_size",
  "default_title_count_mode",
  "default_navigation_menu_categories",
  "default_navigation_menu_tags",
  "default_sidebar_link_to_filtered_list",
  "default_sidebar_show_count_of_new_items",
];
