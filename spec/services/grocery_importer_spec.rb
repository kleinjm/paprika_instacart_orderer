# frozen_string_literal: true

require "rails_helper"

RSpec.describe GroceryImporter do
  describe "#call" do
    it "returns a list of groceries" do
      stub_sample_file_deletion
      groceries =
        described_class.call(user: build_user, json_file: test_data_json)

      expect(groceries.count).to_not be_zero
      expect(groceries).to all(be_a(Grocery))
      expect(File).to have_received(:delete).with(test_data_json)
    end

    it "handles missing groceries json file" do
      stub_sample_file_deletion

      allow(Rails.logger).to receive(:error)
      described_class.call(user: build_user, json_file: "does_not_exist")

      expect(Rails.logger).to have_received(:error).with(
        "Error fetching grocery list from paprika api. No such file or " \
        "directory @ rb_sysopen - does_not_exist\n" \
        "Check that paprika-api JS script is creating the JSON file."
      )
    end

    it "handles file deletion of non-existent file" do
      allow(Rails.logger).to receive(:error)
      described_class.call(user: build_user, json_file: "does_not_exist")

      expect(Rails.logger).to have_received(:error).with(
        "Error fetching grocery list from paprika api. No such file or " \
        "directory @ rb_sysopen - does_not_exist\n" \
        "Check that paprika-api JS script is creating the JSON file."
      )
    end

    it "calls `node` process in production" do
      stub_sample_file_deletion
      allow(Rails.env).to receive(:production?).and_return(true)
      allow(described_class).to receive(:`)

      user = build_user
      described_class.call(user: user, json_file: test_data_json)

      expect(described_class).to have_received(:`).
        with("node #{described_class::JS_FETCH_GROCERIES_SCRIPT} " \
             "#{user.paprika_credentials}")
    end

    it "calls specific `node` process in development" do
      stub_sample_file_deletion
      allow(Rails.env).to receive(:development?).and_return(true)
      allow(described_class).to receive(:`)

      user = build_user
      described_class.call(user: user, json_file: test_data_json)

      node_version = File.read(".nvmrc").strip
      expect(described_class).to have_received(:`).
        with("$HOME/.nvm/versions/node/v#{node_version}/bin/node " \
             "#{described_class::JS_FETCH_GROCERIES_SCRIPT} " \
             "#{user.paprika_credentials}")
    end
  end

  # do not delete test data
  def stub_sample_file_deletion
    allow(File).to receive(:delete)
  end

  def build_user
    instance_double(User, paprika_credentials: "username password")
  end

  def test_data_json
    Rails.root.join("spec", "support", "sample_data", "groceries.json")
  end
end
