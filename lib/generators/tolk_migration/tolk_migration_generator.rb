require 'rails/generators'
require 'rails/generators/migration'

class TolkMigrationGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates/migrate', __FILE__)
  include Rails::Generators::Migration

  # taken from activerecord/lib/generators/active_record.rb - because this includes R::G::Migration, but not Base
  def self.next_migration_number(dirname)
    if ActiveRecord::Base.timestamped_migrations
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    else
      "%.3d" % (current_migration_number(dirname) + 1)
    end
  end
       
  def create_migration_file
    migration_template 'create_tolk_tables.rb', 'db/migrate/create_tolk_tables.rb'
  end
end
