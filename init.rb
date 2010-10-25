Mime::Type.register_alias "text/yaml", :yml

begin  
  ActionController::Pagination
rescue NameError
  classic_pagination = File.join(File.dirname(__FILE__), 'vendor/plugins/classic_pagination')
  $: << File.join(classic_pagination, 'lib')
  require File.join(classic_pagination, 'init')
end

$KCODE = 'UTF8'
begin
  require 'ya2yaml'
rescue LoadError => e
  Rails.logger.debug "[Tolk] Could not load ya2yaml"
end
