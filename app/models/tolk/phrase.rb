module Tolk
  class Phrase < ActiveRecord::Base
    set_table_name "tolk_phrases"

    validates_uniqueness_of :key

    cattr_accessor :per_page
    self.per_page = 30
    
    scope :page, lambda { |page|
      {
        :limit => self.per_page, 
        :offset => (page ? (page.to_i - 1) * per_page : 0)
      }
    }

    has_many :translations, :class_name => 'Tolk::Translation', :dependent => :destroy do
      def primary
        to_a.detect {|t| t.locale_id == Tolk::Locale.primary_locale.id}
      end

      def for(locale)
        to_a.detect {|t| t.locale_id == locale.id}
      end
    end

    attr_accessor :translation
  end
end
