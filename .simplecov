# frozen_string_literal: true

SimpleCov.start "rails" do
  enable_coverage :branch

  add_group "Presenters", "app/presenters"
  add_group "Services", "app/services"

  add_filter "app/channels/"
  add_filter "app/mailers/"
end
