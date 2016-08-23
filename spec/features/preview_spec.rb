require 'rails_helper'

RSpec.feature "Preview", js: true do
  before do
    stub_request(:any, /example.org/)
      .to_return body: <<-EOS
                 <html>
                   <head>
                     <title>Title</title>
                   </head>
                   <body>
                     <h1>Hello world!</h1>
                   </body>
                 </html>
                 EOS
  end

  it "displays most recently fetched page" do
    visit '/monitoring/contexts/new'
    fill_in "Url", with: "http://example.org/"
    click_button "Create Context"

    expect(page).to have_selector 'iframe'

    within_frame 0 do
      expect(page).to have_content "Hello world!"
    end

    stub_request(:any, /example.org/)
      .to_return body: <<-EOS
                 <html>
                   <head>
                     <title>Title</title>
                   </head>
                   <body>
                     <h2>Foo Bar!</h2>
                   </body>
                 </html>
                 EOS

    FetchJob.perform_now(Monitoring::Context.last)

    expect(page).to have_selector 'iframe'

    within_frame 0 do
      expect(page).to have_content 'Foo Bar!'
    end
  end
end
