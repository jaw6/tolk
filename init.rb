$KCODE = 'UTF8'

tolk_lib = File.join(File.dirname(__FILE__), 'vendor/plugins/tolk_lib')
$: << File.join(tolk_lib, 'lib')
require File.join(tolk_lib, 'init')

dynamic_form = File.join(File.dirname(__FILE__), 'vendor/plugins/dynamic_form')
$: << File.join(dynamic_form, 'lib')
require File.join(dynamic_form, 'init')

begin
  require 'ya2yaml'
rescue LoadError => e
  Rails.logger.debug "[Tolk] Could not load ya2yaml"
end
