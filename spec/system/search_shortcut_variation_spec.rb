# frozen_string_literal: true

describe "Search | Shortcuts for variations of search input", type: :system do
  fab!(:current_user) { Fabricate(:user) }

  let(:welcome_banner) { PageObjects::Components::WelcomeBanner.new }
  let(:search_page) { PageObjects::Pages::Search.new }

  before { sign_in(current_user) }

  it "displays a one time toast telling the user that / should be used to search, not Ctrl+F, when Ctrl+F is pressed" do
    visit("/")
    search_page.browser_search_shortcut
    expect(page).to have_content(I18n.t("js.keyboard_shortcuts_help.search_ctrl_f_tip"))
    page.find(".fk-d-default-toast__actions .btn").click
    search_page.browser_search_shortcut
    expect(page).to have_no_content(I18n.t("js.keyboard_shortcuts_help.search_ctrl_f_tip"))
  end

  context "when search_experience is search_field" do
    before { SiteSetting.search_experience = "search_field" }

    context "when enable_welcome_banner is true" do
      before { SiteSetting.enable_welcome_banner = true }

      it "displays and focuses welcome banner search when / is pressed and hides it when Escape is pressed" do
        visit("/")
        expect(welcome_banner).to be_visible
        page.send_keys("/")
        expect(search_page).to have_search_menu
        expect(current_active_element[:id]).to eq("welcome-banner-search-input")
        page.send_keys(:escape)
        expect(search_page).to have_no_search_menu_visible
      end

      context "when welcome banner is not in the viewport" do
        before do
          visit("/")
          fake_scroll_down_long
        end

        it "displays and focuses header search when / is pressed and hides it when Escape is pressed" do
          expect(welcome_banner).to be_invisible
          page.send_keys("/")
          expect(search_page).to have_search_menu
          expect(current_active_element[:id]).to eq("header-search-input")
          page.send_keys(:escape)
          expect(search_page).to have_no_search_menu_visible
        end
      end
    end

    context "when enable_welcome_banner is false" do
      before { SiteSetting.enable_welcome_banner = false }

      it "displays and focuses header search when / is pressed and hides it when Escape is pressed" do
        visit("/")
        expect(welcome_banner).to be_hidden
        page.send_keys("/")
        expect(search_page).to have_search_menu
        expect(current_active_element[:id]).to eq("header-search-input")
        page.send_keys(:escape)
        expect(search_page).to have_no_search_menu_visible
      end
    end
  end

  context "when search_experience is search_icon" do
    before { SiteSetting.search_experience = "search_icon" }

    context "when enable_welcome_banner is true" do
      before { SiteSetting.enable_welcome_banner = true }

      it "displays and focuses welcome banner search when / is pressed and hides it when Escape is pressed" do
        visit("/")
        expect(welcome_banner).to be_visible
        page.send_keys("/")
        expect(search_page).to have_search_menu
        expect(current_active_element[:id]).to eq("welcome-banner-search-input")
        page.send_keys(:escape)
        expect(search_page).to have_no_search_menu_visible
      end

      context "when welcome banner is not in the viewport" do
        before do
          visit("/")
          fake_scroll_down_long
        end

        it "displays and focuses search icon search when / is pressed and hides it when Escape is pressed" do
          expect(welcome_banner).to be_invisible
          page.send_keys("/")
          expect(search_page).to have_search_menu
          expect(current_active_element[:id]).to eq("icon-search-input")
          page.send_keys(:escape)
          expect(search_page).to have_no_search_menu_visible
        end
      end
    end

    context "when enable_welcome_banner is false" do
      before { SiteSetting.enable_welcome_banner = false }

      it "displays and focuses search icon search when / is pressed and hides it when Escape is pressed" do
        visit("/")
        expect(welcome_banner).to be_hidden
        page.send_keys("/")
        expect(search_page).to have_search_menu
        expect(current_active_element[:id]).to eq("icon-search-input")
        page.send_keys(:escape)
        expect(search_page).to have_no_search_menu_visible
      end

      # This search menu only shows within a topic, not in other pages on the site,
      # unlike header search which is always visible.
      context "when within a topic with 20+ posts" do
        fab!(:topic)
        fab!(:posts) { Fabricate.times(21, :post, topic: topic) }

        it "opens search on first press of /, and closes when Escape is pressed" do
          visit "/t/#{topic.slug}/#{topic.id}"
          page.send_keys("/")
          expect(search_page).to have_search_menu
          expect(current_active_element[:id]).to eq("icon-search-input")
          page.send_keys(:escape)
          expect(search_page).to have_no_search_menu_visible
        end
      end
    end
  end
end
