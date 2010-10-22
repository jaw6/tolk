ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'


require "capybara/rails"

module ActionController
  class IntegrationTest
    include Capybara
  end
end

# class Hash
#   undef :ya2yaml
# end

class ActiveSupport::TestCase
  fixtures :tolk_locales, :tolk_phrases, :tolk_translations

  self.fixture_class_names = {:tolk_locales => 'Tolk::Locale', :tolk_phrases => 'Tolk::Phrase', :tolk_translations => 'Tolk::Translation'}
end



# 
# 
# class ActiveSupport::TestCase
#   self.use_transactional_fixtures = true
#   self.use_instantiated_fixtures  = false
# 
#   fixtures :all
# 
# end
