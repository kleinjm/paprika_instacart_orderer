# frozen_string_literal: true

module RequestSpecHelper
  include Warden::Test::Helpers

  def self.included(base)
    base.before(:each) { Warden.test_mode! }
    base.after(:each) { Warden.test_reset! }
  end

  def sign_in(resource)
    login_as(resource, scope: warden_scope(resource))
  end

  def sign_out(resource)
    logout(warden_scope(resource))
  end

  def sign_in_user
    user = create :user
    sign_in(user)
    user
  end

  # check for the data-method that rails adds to a link to make it a destroy
  def expect_destroy_path(response, path)
    expect(destroy_path_hrefs(response, path)).to include path
  end

  def expect_no_destroy_path(response, path)
    expect(destroy_path_hrefs(response, path)).to_not include path
  end

  private

  def destroy_path_hrefs(response, _path)
    html = Nokogiri.HTML(response.body)
    html.css("a[data-method='delete']").map do |link|
      link.attributes["href"].value
    end
  end

  def warden_scope(resource)
    resource.class.name.underscore.to_sym
  end
end

RSpec.configure do |config|
  config.include RequestSpecHelper, type: :controller
  config.include RequestSpecHelper, type: :request
end
