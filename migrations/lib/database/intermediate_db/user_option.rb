# frozen_string_literal: true

# This file is auto-generated from the IntermediateDB schema. To make changes,
# update the "config/intermediate_db.yml" configuration file and then run
# `bin/cli schema generate` to regenerate this file.

module Migrations::Database::IntermediateDB
  module UserOption
    SQL = <<~SQL
      INSERT INTO user_options (
        user_id,
        allow_private_messages,
        auto_track_topics_after_msecs,
        automatically_unpin_topics,
        bookmark_auto_delete_preference,
        chat_email_frequency,
        chat_enabled,
        chat_header_indicator_preference,
        chat_quick_reaction_type,
        chat_quick_reactions_custom,
        chat_send_shortcut,
        chat_separate_sidebar_mode,
        chat_sound,
        color_scheme_id,
        dark_scheme_id,
        default_calendar,
        digest_after_minutes,
        dismissed_channel_retention_reminder,
        dismissed_dm_retention_reminder,
        dynamic_favicon,
        email_digests,
        email_in_reply_to,
        email_level,
        email_messages_level,
        email_previous_replies,
        enable_allowed_pm_users,
        enable_defer,
        enable_experimental_sidebar,
        enable_quoting,
        enable_smart_lists,
        external_links_in_new_tab,
        hide_presence,
        hide_profile,
        hide_profile_and_presence,
        homepage_id,
        ignore_channel_wide_mention,
        include_tl0_in_digests,
        last_redirected_to_top_at,
        like_notification_frequency,
        mailing_list_mode,
        mailing_list_mode_frequency,
        new_topic_duration_minutes,
        notification_level_when_replying,
        oldest_search_log_date,
        only_chat_push_notifications,
        seen_popups,
        show_thread_title_prompts,
        sidebar_link_to_filtered_list,
        sidebar_show_count_of_new_items,
        skip_new_user_tips,
        text_size_key,
        text_size_seq,
        theme_ids,
        theme_key_seq,
        timezone,
        title_count_mode_key,
        topics_unread_when_closed,
        watched_precedence_over_muted
      )
      VALUES (
        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,
        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?
      )
    SQL

    def self.create(
      user_id:,
      allow_private_messages: nil,
      auto_track_topics_after_msecs: nil,
      automatically_unpin_topics: nil,
      bookmark_auto_delete_preference: nil,
      chat_email_frequency: nil,
      chat_enabled: nil,
      chat_header_indicator_preference: nil,
      chat_quick_reaction_type: nil,
      chat_quick_reactions_custom: nil,
      chat_send_shortcut: nil,
      chat_separate_sidebar_mode: nil,
      chat_sound: nil,
      color_scheme_id: nil,
      dark_scheme_id: nil,
      default_calendar: nil,
      digest_after_minutes: nil,
      dismissed_channel_retention_reminder: nil,
      dismissed_dm_retention_reminder: nil,
      dynamic_favicon: nil,
      email_digests: nil,
      email_in_reply_to: nil,
      email_level: nil,
      email_messages_level: nil,
      email_previous_replies: nil,
      enable_allowed_pm_users: nil,
      enable_defer: nil,
      enable_experimental_sidebar: nil,
      enable_quoting: nil,
      enable_smart_lists: nil,
      external_links_in_new_tab: nil,
      hide_presence: nil,
      hide_profile: nil,
      hide_profile_and_presence: nil,
      homepage_id: nil,
      ignore_channel_wide_mention: nil,
      include_tl0_in_digests: nil,
      last_redirected_to_top_at: nil,
      like_notification_frequency: nil,
      mailing_list_mode: nil,
      mailing_list_mode_frequency: nil,
      new_topic_duration_minutes: nil,
      notification_level_when_replying: nil,
      oldest_search_log_date: nil,
      only_chat_push_notifications: nil,
      seen_popups: nil,
      show_thread_title_prompts: nil,
      sidebar_link_to_filtered_list: nil,
      sidebar_show_count_of_new_items: nil,
      skip_new_user_tips: nil,
      text_size_key: nil,
      text_size_seq: nil,
      theme_ids: nil,
      theme_key_seq: nil,
      timezone: nil,
      title_count_mode_key: nil,
      topics_unread_when_closed: nil,
      watched_precedence_over_muted: nil
    )
      ::Migrations::Database::IntermediateDB.insert(
        SQL,
        user_id,
        ::Migrations::Database.format_boolean(allow_private_messages),
        auto_track_topics_after_msecs,
        ::Migrations::Database.format_boolean(automatically_unpin_topics),
        bookmark_auto_delete_preference,
        chat_email_frequency,
        ::Migrations::Database.format_boolean(chat_enabled),
        chat_header_indicator_preference,
        chat_quick_reaction_type,
        chat_quick_reactions_custom,
        chat_send_shortcut,
        chat_separate_sidebar_mode,
        chat_sound,
        color_scheme_id,
        dark_scheme_id,
        default_calendar,
        digest_after_minutes,
        ::Migrations::Database.format_boolean(dismissed_channel_retention_reminder),
        ::Migrations::Database.format_boolean(dismissed_dm_retention_reminder),
        ::Migrations::Database.format_boolean(dynamic_favicon),
        ::Migrations::Database.format_boolean(email_digests),
        ::Migrations::Database.format_boolean(email_in_reply_to),
        email_level,
        email_messages_level,
        email_previous_replies,
        ::Migrations::Database.format_boolean(enable_allowed_pm_users),
        ::Migrations::Database.format_boolean(enable_defer),
        ::Migrations::Database.format_boolean(enable_experimental_sidebar),
        ::Migrations::Database.format_boolean(enable_quoting),
        ::Migrations::Database.format_boolean(enable_smart_lists),
        ::Migrations::Database.format_boolean(external_links_in_new_tab),
        ::Migrations::Database.format_boolean(hide_presence),
        ::Migrations::Database.format_boolean(hide_profile),
        ::Migrations::Database.format_boolean(hide_profile_and_presence),
        homepage_id,
        ::Migrations::Database.format_boolean(ignore_channel_wide_mention),
        ::Migrations::Database.format_boolean(include_tl0_in_digests),
        ::Migrations::Database.format_datetime(last_redirected_to_top_at),
        like_notification_frequency,
        ::Migrations::Database.format_boolean(mailing_list_mode),
        mailing_list_mode_frequency,
        new_topic_duration_minutes,
        notification_level_when_replying,
        ::Migrations::Database.format_datetime(oldest_search_log_date),
        ::Migrations::Database.format_boolean(only_chat_push_notifications),
        seen_popups,
        ::Migrations::Database.format_boolean(show_thread_title_prompts),
        ::Migrations::Database.format_boolean(sidebar_link_to_filtered_list),
        ::Migrations::Database.format_boolean(sidebar_show_count_of_new_items),
        ::Migrations::Database.format_boolean(skip_new_user_tips),
        text_size_key,
        text_size_seq,
        theme_ids,
        theme_key_seq,
        timezone,
        title_count_mode_key,
        ::Migrations::Database.format_boolean(topics_unread_when_closed),
        ::Migrations::Database.format_boolean(watched_precedence_over_muted),
      )
    end
  end
end
