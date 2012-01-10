require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'cancan/matchers'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    # == Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
    config.mock_with :rspec

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = true

    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = false

    config.include FactoryGirl::Syntax::Methods
    config.include Capybara::DateSelect
    config.include Capybara::SessionHelper
    config.include Capybara::SubdomainHelper
    config.include WCACompetitions::SpecHelper

    config.extend VCR::RSpec::Macros

    config.around(:each, :caching) do |example|
      caching = ActionController::Base.perform_caching
      ActionController::Base.perform_caching = example.metadata[:caching]
      example.run
      ActionController::Base.perform_caching = caching
    end

    config.before(:each) do
      if respond_to?(:app)
        app.default_url_options = { :locale => I18n.locale }
      end
    end

    config.after(:each) do
      I18n.locale = I18n.default_locale
      Capybara.app_host = "http://example.com"
    end
  end
end

Spork.each_run do
  # This code will be run each time you run your specs.
end