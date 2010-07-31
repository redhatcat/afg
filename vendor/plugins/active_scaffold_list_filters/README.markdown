

ActiveScaffoldListFilters
-------------------------

Copyright (c) 2008 Tys von Gaza (tys@gotoybox.com)

MIT License use as you wish, see MIT-LICENSE file

Version 0.5

[Preview](http://farm4.static.flickr.com/3402/3257194048_1b75c0b966_o.png)

Add a filter menu at the top of the ActiveScaffold List view.  The filter can be whatever you dream up.  Code inspiration: activescaffoldexport plugin.

### Todo/Know Bugs (Please Help!):

  * Have the reset link not close the filter, but actually reset it.
  * Tests need to be created!  I don't have much experience here, help or advice welcome.
  * Ability to get a count of rows in the _current_ list for each association in the association filter.  Ie color the options different if there is results or not.  Tricky, need to update the filter along with the list.  Thoughts?
  * Doesn't javascript degrade... not an issue in our project so won't fix.

### Ideas for filters:

  * Map, 100km's from point (Geokit / "Haversine_formula":http://en.wikipedia.org/wiki/Haversine_formula)
  * iTunes style browser (update categories as you filter)

### Installing:

  * ./script/plugin install git://github.com/tvongaza/active_scaffold_list_filters.git
  * Add to your application.rb default action list or to an individual controller: app/controllers/application.rb

    class ApplicationController < ActionController::Base
      ActiveScaffold.set_defaults do |config|
        config.actions.add :list_filter
      end
    end

or an individual controller

    active_scaffold "Model" do |config|
      config.actions.add :list_filter
    end

  * Add a filter, the form is:
    * config.list_filter.add(:filter_type, :filter_name, {:label => "Filter Label", :other_key => "options"})
    * :filter_type is the type of filter, ie :association or :date
    * :filter_name is the name you want to use for the filter, should be unique in your scaffold
    * {} options hash
      * :label is the label of the filter, defaults to what you have set in :filter_name above
      * :other_key is filter specific

Add an Association (checkboxes) filter, named district, with the label Districts, note the association filter by default uses the filter_name parameter as the association name by default:

    active_scaffold "Model" do |config|
      config.list_filter.add(:association, :district, {:label => "Districts")
    end

Add an Association (checkboxes) filter, named city, with the label Cities, but using the association named town:

    active_scaffold "Model" do |config|
      config.list_filter.add(:association, :city, {:label => "Cities", :association => :town)
    end


### Creating your own filters:

It is simple to create your own filter.

  * Choose a name to use, ie "association".
  * Create a partial template for the filter in app/views/active_scaffold_list_filters, ie: app/views/active_scaffold_list_filters/_association.rhtml
  * Use this to create a way for your user to interact with your filter. You have access to a ListFilter object (see vendor/plugins/lib/active_scaffold/data_structures/list_filter.rb), which you'll later extend with your own methods.  This object allows you get your filters type, name, and options set in the controller.
    * Your filter view must set form fields.  Use the list_filter_input_name(filter) to get a base name to use.
    * If you're setting more then one field then use form array's, ie: list_filter_input_name(filter)['field2'], or if you're using checkboxes or multi select menu's you can use an array like so:

            list_filter_input_name(filter)[]

  * Create a new List Filter in app/controllers/list_filters, ie: app/controllers/list_filters/association.rb.  This file must have the following layout:

        class ListFilters::Association < ActiveScaffold::DataStructures::ListFilter

  * Return a list of finder options

        def find_options
          begin
            assocation = @core.model.reflect_on_association(assocation_name)
            options = {}
            options[:include] = assocation_name
            options[:conditions] = ["#{assocation.klass.table_name}.id IN (?)", params]

            return options
          end unless params.nil? || params.empty?
        end

    * You must then define the method find_options(params) to return a list of filter finder options.  These will be used to filter your table's data.
    * You have access to your the ListFilter that you're extending again with the same properties as above.  You also have a list of parameters from your view.
    * This file can also contain custom methods used in your view or conditions, sky is the limit!

  * There is a second required method verbose, which will throw what is being filtered into the flash[:info]

        def verbose
          begin
          ar_class = association_tree.last.class_name.constantize
            associated_values = ar_class.find(params).sort {|a,b| a.to_label <=> b.to_label }
            verbose_values = associated_values.collect{|av| av.to_label}.join(", ")
            return verbose_values
          end unless params.nil? || params.empty?
        end

  * Upload your filter object and view for others to use and improve!
