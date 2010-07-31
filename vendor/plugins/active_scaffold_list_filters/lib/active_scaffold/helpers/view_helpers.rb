module ActiveScaffold
  module Helpers::ViewHelpers
  
    def active_scaffold_stylesheets_with_list_filter(frontend = :default)
      active_scaffold_stylesheets_without_list_filter + [ActiveScaffold::Config::Core.asset_path('list_filter-stylesheet.css', frontend)]
    end
    alias_method_chain :active_scaffold_stylesheets, :list_filter
    
    def active_scaffold_ie_stylesheets_with_list_filter(frontend = :default)
      active_scaffold_ie_stylesheets_without_list_filter + [ActiveScaffold::Config::Core.asset_path('list_filter-stylesheet-ie.css', frontend)]
    end
    alias_method_chain :active_scaffold_ie_stylesheets, :list_filter
  
  end
end
