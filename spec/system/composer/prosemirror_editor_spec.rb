# frozen_string_literal: true

describe "Composer - ProseMirror editor", type: :system do
  fab!(:user) { Fabricate(:user, refresh_auto_groups: true) }
  fab!(:tag)
  let(:cdp) { PageObjects::CDP.new }
  let(:composer) { PageObjects::Components::Composer.new }
  let(:rich) { composer.rich_editor }

  before do
    sign_in(user)
    SiteSetting.rich_editor = true
  end

  def open_composer_and_toggle_rich_editor
    page.visit "/new-topic"
    expect(composer).to be_opened
    composer.toggle_rich_editor
    composer.focus
  end

  it "hides the Composer container's preview button" do
    page.visit "/new-topic"

    expect(composer).to be_opened
    expect(composer).to have_composer_preview_toggle

    composer.toggle_rich_editor

    expect(composer).to have_no_composer_preview_toggle
  end

  context "with autocomplete" do
    it "triggers an autocomplete on mention" do
      open_composer_and_toggle_rich_editor
      composer.type_content("@#{user.username}")

      expect(composer).to have_mention_autocomplete
    end

    it "triggers an autocomplete on hashtag" do
      open_composer_and_toggle_rich_editor
      composer.type_content("##{tag.name}")

      expect(composer).to have_hashtag_autocomplete
    end

    it "triggers an autocomplete on emoji" do
      open_composer_and_toggle_rich_editor
      composer.type_content(":smile")

      expect(composer).to have_emoji_autocomplete
    end

    it "strips partially written emoji when using 'more' emoji modal" do
      open_composer_and_toggle_rich_editor
      composer.type_content("Why :repeat_single")

      expect(composer).to have_emoji_autocomplete

      # "more" emoji picker
      composer.send_keys(:arrow_down, :enter)

      find("img[data-emoji='repeat_single_button']").click

      composer.toggle_rich_editor

      expect(composer).to have_value("Why :repeat_single_button: ")
    end
  end

  context "with inputRules" do
    it "supports > to create a blockquote" do
      open_composer_and_toggle_rich_editor
      composer.type_content("> This is a blockquote")

      expect(rich).to have_css("blockquote", text: "This is a blockquote")
    end

    it "supports n. to create an ordered list" do
      open_composer_and_toggle_rich_editor
      composer.type_content("1. Item 1\n5. Item 2")

      expect(rich).to have_css("ol li", text: "Item 1")
      expect(find("ol ol", text: "Item 2")["start"]).to eq("5")
    end

    it "supports *, - or + to create an unordered list" do
      open_composer_and_toggle_rich_editor
      composer.type_content("* Item 1\n")
      composer.type_content("- Item 2\n")
      composer.type_content("+ Item 3")

      expect(rich).to have_css("ul ul li", count: 3)
    end

    it "uses 'tight' lists for both ordered and unordered lists by default" do
      open_composer_and_toggle_rich_editor
      composer.type_content("1. Item 1\n5. Item 2\n\n")
      composer.type_content("* Item 1\n* Item 2")
      expect(rich).to have_css("ol[data-tight='true']")
      expect(rich).to have_css("ul[data-tight='true']")
    end

    it "supports ``` or 4 spaces to create a code block" do
      open_composer_and_toggle_rich_editor
      composer.type_content("```\nThis is a code block")
      composer.send_keys(%i[shift enter])
      composer.type_content("    This is a code block")

      expect(rich).to have_css("pre code", text: "This is a code block", count: 2)
    end

    it "supports 1-6 #s to create a heading" do
      open_composer_and_toggle_rich_editor
      composer.type_content("# Heading 1\n")
      composer.type_content("## Heading 2\n")
      composer.type_content("### Heading 3\n")
      composer.type_content("#### Heading 4\n")
      composer.type_content("##### Heading 5\n")
      composer.type_content("###### Heading 6\n")

      expect(rich).to have_css("h1", text: "Heading 1")
      expect(rich).to have_css("h2", text: "Heading 2")
      expect(rich).to have_css("h3", text: "Heading 3")
      expect(rich).to have_css("h4", text: "Heading 4")
      expect(rich).to have_css("h5", text: "Heading 5")
      expect(rich).to have_css("h6", text: "Heading 6")
    end

    it "supports _ or * to create an italic text" do
      open_composer_and_toggle_rich_editor
      composer.type_content("_This is italic_\n")
      composer.type_content("*This is italic*")

      expect(rich).to have_css("em", text: "This is italic", count: 2)
    end

    it "supports __ or ** to create a bold text" do
      open_composer_and_toggle_rich_editor
      composer.type_content("__This is bold__\n")
      composer.type_content("**This is bold**")

      expect(rich).to have_css("strong", text: "This is bold", count: 2)
    end

    it "supports ` to create a code text" do
      open_composer_and_toggle_rich_editor
      composer.type_content("`This is code`")

      expect(rich).to have_css("code", text: "This is code")
    end

    it "supports typographer replacements" do
      open_composer_and_toggle_rich_editor
      composer.type_content(
        "foo +- bar... test???? wow!!!! x,, y-- --- a--> b<-- c-> d<- e<-> f<--> (tm) (pa)",
      )

      expect(rich).to have_css(
        "p",
        text: "foo ± bar… test??? wow!!! x, y– — a–> b←- c→ d← e←> f←→ ™ ¶",
      )
    end

    it "supports ---, ***, ___, en-dash+hyphen, em-dash+hyphen to create a horizontal rule" do
      open_composer_and_toggle_rich_editor
      composer.type_content("Hey\n---There\n*** Friend\n___ How\n\u2013-are\n\u2014-you")

      expect(rich).to have_css("hr", count: 5)
    end
  end

  context "with oneboxing" do
    let(:cdp) { PageObjects::CDP.new }

    before do
      def body(title)
        <<~HTML
          <html>
            <head>
              <title>#{title}</title>
              <meta property="og:title" content="#{title}">
              <meta property="og:description" content="This is an example site">
            </head>
            <body>
              <h1>#{title}</h1>
              <p>This domain is for use in examples.</p>
            </body>
          </html>
        HTML
      end

      stub_request(:head, %r{https://example\.com.*}).to_return(status: 200)
      stub_request(:get, %r{https://example\.com.*}).to_return(
        status: 200,
        body: body("Example Site 1"),
      )

      stub_request(:head, %r{https://example2\.com.*}).to_return(status: 200)
      stub_request(:get, %r{https://example2\.com.*}).to_return(
        status: 200,
        body: body("Example Site 2"),
      )

      stub_request(:head, %r{https://example3\.com.*}).to_return(status: 200)
      stub_request(:get, %r{https://example3\.com.*}).to_return(
        status: 200,
        body: body("Example Site 3"),
      )
    end

    it "creates an inline onebox for links within text" do
      cdp.allow_clipboard
      open_composer_and_toggle_rich_editor
      composer.type_content("Check out this link ")
      cdp.write_clipboard("https://example.com/x")
      page.send_keys([PLATFORM_KEY_MODIFIER, "v"])
      composer.type_content(" ").type_content("in the middle of text")

      expect(rich).to have_css(
        "a.inline-onebox[href='https://example.com/x']",
        text: "Example Site 1",
      )

      composer.toggle_rich_editor

      expect(composer).to have_value(
        "Check out this link https://example.com/x in the middle of text",
      )
    end

    it "creates a full onebox for standalone links" do
      cdp.allow_clipboard
      open_composer_and_toggle_rich_editor
      cdp.write_clipboard("https://example.com")
      page.send_keys([PLATFORM_KEY_MODIFIER, "v"])
      page.send_keys(:enter)

      expect(rich).to have_css("div.onebox-wrapper[data-onebox-src='https://example.com']")
      expect(rich).to have_content("Example Site 1")
      expect(rich).to have_content("This is an example site")

      composer.toggle_rich_editor

      expect(composer).to have_value("https://example.com\n\n")
    end

    it "creates an inline onebox for links that are part of a paragraph" do
      cdp.allow_clipboard
      open_composer_and_toggle_rich_editor
      composer.type_content("Some text ")
      cdp.write_clipboard("https://example.com/x")
      page.send_keys([PLATFORM_KEY_MODIFIER, "v"])
      composer.type_content(" ").type_content("more text")

      expect(rich).to have_no_css("div.onebox-wrapper")
      expect(rich).to have_css("a.inline-onebox", text: "Example Site 1")

      composer.toggle_rich_editor

      expect(composer).to have_value("Some text https://example.com/x more text")
    end

    it "does not create oneboxes inside code blocks" do
      cdp.allow_clipboard
      open_composer_and_toggle_rich_editor
      composer.type_content("```")
      cdp.write_clipboard("https://example.com")
      page.send_keys([PLATFORM_KEY_MODIFIER, "v"])

      expect(rich).to have_css("pre code")
      expect(rich).to have_no_css("div.onebox-wrapper")
      expect(rich).to have_no_css("a.inline-onebox")
      expect(rich).to have_content("https://example.com")

      composer.toggle_rich_editor

      expect(composer).to have_value("```\nhttps://example.com\n```")
    end

    it "creates oneboxes for mixed content" do
      cdp.allow_clipboard
      open_composer_and_toggle_rich_editor
      markdown = <<~MARKDOWN
        https://example.com

        Check this https://example.com/x and see if it fits you

        https://example2.com

        An inline to https://example2.com/x with text around it

        https://example3.com

        Another one for https://example3.com/x then

        https://example.com

        Phew, repeating https://example.com/x now

        https://example2.com

        And some text again https://example2.com/x

        https://example3.com/x

        Ok, that is it https://example3.com/x
        After a hard break
      MARKDOWN
      cdp.write_clipboard(markdown)
      page.send_keys([PLATFORM_KEY_MODIFIER, "v"])

      expect(rich).to have_css("a.inline-onebox", count: 6)
      expect(rich).to have_css(
        "a.inline-onebox[href='https://example.com/x']",
        text: "Example Site 1",
      )
      expect(rich).to have_css(
        "a.inline-onebox[href='https://example2.com/x']",
        text: "Example Site 2",
      )
      expect(rich).to have_css(
        "a.inline-onebox[href='https://example3.com/x']",
        text: "Example Site 3",
      )

      expect(rich).to have_css("div.onebox-wrapper", count: 6)
      expect(rich).to have_css("div.onebox-wrapper[data-onebox-src='https://example.com']")
      expect(rich).to have_css("div.onebox-wrapper[data-onebox-src='https://example2.com']")
      expect(rich).to have_css("div.onebox-wrapper[data-onebox-src='https://example3.com']")

      composer.toggle_rich_editor

      expect(composer).to have_value(markdown[0..-2])
    end

    it "creates inline oneboxes for repeated links in different paste events" do
      cdp.allow_clipboard
      open_composer_and_toggle_rich_editor
      composer.type_content("Hey ")
      cdp.write_clipboard("https://example.com/x")
      page.send_keys([PLATFORM_KEY_MODIFIER, "v"])
      composer.type_content(" ").type_content("and").type_content(" ")
      page.send_keys([PLATFORM_KEY_MODIFIER, "v"])
      composer.type_content("\n")

      expect(rich).to have_css(
        "a.inline-onebox[href='https://example.com/x']",
        text: "Example Site 1",
        count: 2,
      )

      composer.toggle_rich_editor

      expect(composer).to have_value("Hey https://example.com/x and https://example.com/x")
    end
  end

  context "with keymap" do
    PLATFORM_KEY_MODIFIER = SystemHelpers::PLATFORM_KEY_MODIFIER
    it "supports Ctrl + B to create a bold text" do
      open_composer_and_toggle_rich_editor
      composer.type_content([PLATFORM_KEY_MODIFIER, "b"])
      composer.type_content("This is bold")

      expect(rich).to have_css("strong", text: "This is bold")
    end

    it "supports Ctrl + I to create an italic text" do
      open_composer_and_toggle_rich_editor
      composer.type_content([PLATFORM_KEY_MODIFIER, "i"])
      composer.type_content("This is italic")

      expect(rich).to have_css("em", text: "This is italic")
    end

    xit "supports Ctrl + K to create a link" do
      open_composer_and_toggle_rich_editor
      page.send_keys([PLATFORM_KEY_MODIFIER, "k"])
      page.send_keys("https://www.example.com\t")
      page.send_keys("This is a link")
      page.send_keys(:enter)

      expect(rich).to have_css("a", text: "This is a link")
    end

    it "supports Ctrl + Shift + 7 to create an ordered list" do
      open_composer_and_toggle_rich_editor
      composer.type_content("Item 1")
      composer.send_keys([PLATFORM_KEY_MODIFIER, :shift, "7"])

      expect(rich).to have_css("ol li", text: "Item 1")
    end

    it "supports Ctrl + Shift + 8 to create a bullet list" do
      open_composer_and_toggle_rich_editor
      composer.type_content("Item 1")
      composer.send_keys([PLATFORM_KEY_MODIFIER, :shift, "8"])

      expect(rich).to have_css("ul li", text: "Item 1")
    end

    it "supports Ctrl + Shift + 9 to create a blockquote" do
      open_composer_and_toggle_rich_editor
      composer.type_content("This is a blockquote")
      composer.send_keys([PLATFORM_KEY_MODIFIER, :shift, "9"])

      expect(rich).to have_css("blockquote", text: "This is a blockquote")
    end

    it "supports Ctrl + Shift + 1-6 for headings, 0 for reset" do
      open_composer_and_toggle_rich_editor
      (1..6).each do |i|
        composer.type_content("\nHeading #{i}")
        composer.send_keys([PLATFORM_KEY_MODIFIER, :shift, i.to_s])

        expect(rich).to have_css("h#{i}", text: "Heading #{i}")
      end

      composer.send_keys([PLATFORM_KEY_MODIFIER, :shift, "0"])
      expect(rich).not_to have_css("h6")
    end

    it "supports Ctrl + Z and Ctrl + Shift + Z to undo and redo" do
      open_composer_and_toggle_rich_editor
      composer.type_content("This is a test")
      composer.send_keys([PLATFORM_KEY_MODIFIER, "z"])

      expect(rich).not_to have_css("p", text: "This is a test")

      composer.send_keys([PLATFORM_KEY_MODIFIER, :shift, "z"])

      expect(rich).to have_css("p", text: "This is a test")
    end

    it "supports Ctrl + Shift + _ to create a horizontal rule" do
      open_composer_and_toggle_rich_editor
      composer.type_content("This is a test")
      composer.send_keys([PLATFORM_KEY_MODIFIER, :shift, "_"])

      expect(rich).to have_css("hr")
    end

    it "supports Backspace to reset a heading" do
      open_composer_and_toggle_rich_editor
      composer.type_content("# With text")

      expect(rich).to have_css("h1", text: "With text")

      composer.send_keys(:home)
      composer.send_keys(:backspace)

      expect(rich).to have_css("p", text: "With text")
    end

    it "supports Backspace to reset a code_block" do
      open_composer_and_toggle_rich_editor
      composer.type_content("```code block")
      composer.send_keys(:home)
      composer.send_keys(%i[backspace])

      expect(rich).to have_css("p", text: "code block")
    end

    it "doesn't add a new list item when backspacing from below a list" do
      open_composer_and_toggle_rich_editor
      composer.type_content("1. Item 1\nItem 2")
      composer.send_keys(:down)
      composer.type_content("Item 3")
      composer.send_keys(:home)
      composer.send_keys(:backspace)

      expect(rich).to have_css("ol li", text: "Item 1")
      expect(rich).to have_css("ol li", text: "Item 2Item 3")
    end
  end

  describe "pasting content" do
    it "does not freeze the editor when pasting markdown code blocks without a language" do
      cdp.allow_clipboard
      open_composer_and_toggle_rich_editor

      # The example is a bit convoluted, but it's the simplest way to reproduce the issue.
      cdp.write_clipboard <<~MARKDOWN
        ```
        puts SiteSetting.all_settings(filter_categories: ["uncategorized"]).map { |setting| setting[:setting] }.join("\n")
        ```
      MARKDOWN
      composer.type_content("This is a test\n\n")
      page.send_keys([PLATFORM_KEY_MODIFIER, "v"])
      expect(page.driver.browser.logs.get(:browser)).not_to include(
        "Maximum call stack size exceeded",
      )
      expect(rich).to have_css("pre code", wait: 1)
      expect(rich).to have_css("select.code-language-select", wait: 1)
    end

    it "parses images copied from cooked with base62-sha1" do
      cdp.allow_clipboard
      open_composer_and_toggle_rich_editor

      cdp.write_clipboard(
        '<img src="image.png" alt="alt text" data-base62-sha1="1234567890">',
        html: true,
      )
      page.send_keys([PLATFORM_KEY_MODIFIER, "v"])

      expect(page).to have_css(
        "img[src$='image.png'][alt='alt text'][data-orig-src='upload://1234567890']",
      )
    end

    it "respects existing marks when pasting a url to make a link" do
      cdp.allow_clipboard
      open_composer_and_toggle_rich_editor
      cdp.write_clipboard("not selected `code`**bold**not*italic* not selected")
      page.send_keys([PLATFORM_KEY_MODIFIER, "v"])
      rich.find("strong").double_click

      cdp.write_clipboard("www.example.com")
      page.send_keys([PLATFORM_KEY_MODIFIER, "v"])

      expect(rich).to have_css("code", text: "code")
      expect(rich).to have_css("strong", text: "bold")
      expect(rich).to have_css("em", text: "italic")

      composer.toggle_rich_editor

      expect(composer).to have_value(
        "not selected [`code`**bold**not*italic*](www.example.com) not selected",
      )
    end

    it "auto-links pasted URLs from text/html" do
      cdp.allow_clipboard
      open_composer_and_toggle_rich_editor

      cdp.write_clipboard("not selected **bold** not selected")
      page.send_keys([PLATFORM_KEY_MODIFIER, "v"])
      rich.find("strong").double_click

      cdp.write_clipboard("<p>www.example.com</p>", html: true)
      page.send_keys([PLATFORM_KEY_MODIFIER, "v"])

      composer.toggle_rich_editor

      expect(composer).to have_value("not selected **[bold](www.example.com)** not selected")
    end
  end

  describe "trailing paragraph" do
    it "ensures there is always a trailing paragraph" do
      open_composer_and_toggle_rich_editor

      expect(rich).to have_css("p", count: 1)
      composer.type_content("This is a test")

      expect(rich).to have_css("p", count: 1)
      expect(rich).to have_css("p", text: "This is a test", count: 1)

      composer.send_keys([PLATFORM_KEY_MODIFIER, :shift, "_"]) # Insert a horizontal rule
      expect(rich).to have_css("hr", count: 1)
      expect(rich).to have_css("p", count: 2) # New paragraph inserted after the ruler
    end
  end

  describe "auto-linking/unlinking" do
    it "auto-links non-protocol URLs and removes the link when no longer a URL" do
      open_composer_and_toggle_rich_editor

      composer.type_content("www.example.com")

      expect(rich).to have_css("a", text: "www.example.com")

      composer.send_keys(%i[backspace backspace])

      expect(rich).to have_no_css("a")

      composer.type_content("om")

      expect(rich).to have_css("a", text: "www.example.com")
    end

    it "auto-links protocol URLs" do
      open_composer_and_toggle_rich_editor

      composer.type_content("https://example.com")

      expect(rich).to have_css("a", text: "https://example.com")

      composer.send_keys(%i[backspace backspace])

      expect(rich).to have_css("a", text: "https://example.c")
    end
  end

  describe "uploads" do
    it "handles uploads and disables the editor toggle while uploading" do
      open_composer_and_toggle_rich_editor

      file_path = file_from_fixtures("logo.png", "images").path
      cdp.with_slow_upload do
        attach_file(file_path) { composer.click_toolbar_button("upload") }
        expect(composer).to have_in_progress_uploads
        expect(composer.editor_toggle_switch).to be_disabled
      end

      expect(composer).to have_no_in_progress_uploads
      expect(rich).to have_css("img", count: 1)
    end
  end

  describe "code marks with fake cursor" do
    it "allows typing after a code mark with/without the mark" do
      open_composer_and_toggle_rich_editor

      composer.type_content("This is ~~SPARTA!~~ `code!`.")

      expect(rich).to have_css("code", text: "code!")

      # within the code mark
      composer.send_keys(%i[backspace backspace])
      composer.type_content("!")

      expect(rich).to have_css("code", text: "code!")

      # after the code mark
      composer.send_keys(:right)
      composer.type_content(".")

      composer.toggle_rich_editor

      expect(composer).to have_value("This is ~~SPARTA!~~ `code!`.")
    end

    xit "allows typing before a code mark with/without the mark" do
      open_composer_and_toggle_rich_editor

      composer.type_content("`code mark`")

      expect(rich).to have_css("code", text: "code mark")

      # before the code mark
      composer.send_keys(:home)
      composer.send_keys(:left)
      composer.type_content("..")

      # within the code mark
      composer.send_keys(:right)
      composer.type_content("!!")

      composer.toggle_rich_editor

      expect(composer).to have_value("..`!!code mark`")
    end
  end

  describe "emojis" do
    it "has the only-emoji class if 1-3 emojis are 'alone'" do
      open_composer_and_toggle_rich_editor

      composer.type_content("> :smile: ")

      expect(rich).to have_css(".only-emoji", count: 1)

      composer.type_content(":P ")

      expect(rich).to have_css(".only-emoji", count: 2)

      composer.type_content(":D ")

      expect(rich).to have_css(".only-emoji", count: 3)

      composer.type_content("Hey!")

      expect(rich).to have_no_css(".only-emoji")
    end
  end
end
