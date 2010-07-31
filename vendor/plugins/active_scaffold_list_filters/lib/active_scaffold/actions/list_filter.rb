module ActiveScaffold::Actions
  module ListFilter
    def self.included(base)
      # add app/views/active_scaffold_list_filters to the view paths for custom filters
      ActionController::Base.view_paths.each do |dir|
        if File.exists?(File.join(dir,"active_scaffold_list_filters"))
          base.add_active_scaffold_path(File.join(dir,"active_scaffold_list_filters"))
        end
      end

      # Add default frontend path
      active_scaffold_default_frontend_path = File.join(Rails.root, 'vendor', 'plugins', File.expand_path(__FILE__).match(/vendor\/plugins\/([^\/]*)/)[1], 'frontends', 'default' , 'views')
      base.add_active_scaffold_path(active_scaffold_default_frontend_path)

      base.before_filter :list_filter_authorized?, :only => [:list_filter]
      base.before_filter :init_filter_session_var
      base.before_filter :do_list_filter, :only => [:list, :index]
    end

    # todo, clean this up!!!
    def init_filter_session_var
      # check if how we're filtering
      if !params["list_filter"].nil?
        if params["list_filter"]["input"] == "filter"
          if not params["list_filter"]["load_filter_name"].blank?
            load_list_filter
          elsif not params["list_filter"]["delete_filter_name"].blank?
            delete_list_filter
          else
            active_scaffold_session_storage["list_filter"] = params["list_filter"]
          end
        elsif params["list_filter"]["input"] == "save" and
          not params["list_filter"]["filter_name"].blank?
          save_list_filter
        elsif params["list_filter"]["input"] == "reset"
          active_scaffold_session_storage["list_filter"] = nil
        end
      end
    end

    def list_filter
      # setup our view path
      #       append_view_path "app/list_filters"
      #       append_view_path "#{File.dirname(__FILE__)}/../../list_filters"
      filter_config = active_scaffold_config.list_filter
      respond_to do |wants|
        wants.html do
          if successful?
            render(:partial => 'list_filter', :locals => { :filter_config => filter_config }, :layout => true)
          else
            return_to_main
          end
        end
        wants.js do
          render(:partial => 'list_filter', :locals => { :filter_config => filter_config }, :layout => false)
        end
      end
    end

    protected

    def do_list_filter
      verbose_filter = []
      active_scaffold_config.list_filter.filters.each do |filter|
        filter_session = active_scaffold_session_storage["list_filter"] unless active_scaffold_session_storage["list_filter"].nil?
        filter_session = filter_session[filter.filter_type] unless filter_session.nil?
        filter_session = filter_session[filter.name] unless filter_session.nil?
        filter.session = filter_session

        # set our conditions
        find_options = filter.find_options
        conditions = find_options[:conditions] unless find_options.nil?
        self.active_scaffold_conditions = merge_conditions(self.active_scaffold_conditions, conditions)

        # set our joins
        joins = find_options[:include] unless find_options.nil?
        self.active_scaffold_includes.concat [joins].flatten.uniq.compact unless joins.nil?

        active_scaffold_config.list.user.page = nil
        verbose_filter << "#{filter.label} (#{filter.verbose})" unless filter.verbose.nil?
        @filtered = !filter.verbose.nil?
      end

      set_flash(verbose_filter)
    end

    def set_flash(verbose_filter)
      if flash[:info].nil?
        flash[:info] = ""
      end
      flashes = []
      flashes << "Searching on: #{params[:search]}" unless params[:search].nil? || params[:search] == ""
      flashes << "Filtering on: #{verbose_filter.join(', ')}" unless verbose_filter.empty?
      flash[:info] = flashes.join(" | ")
      if flash[:info].blank?
        flash.delete(:info)
      end
    end

    def save_list_filter
      filter_config = active_scaffold_config.list_filter
      filter_name = params["list_filter"]["filter_name"]
      if filter_config.filter_save_class
        filter_config.filter_save_class.save(current_user.id,
          filter_name, active_scaffold_session_storage["list_filter"])
      else
        saved_filters = active_scaffold_config.list_filter.user.saved_list_filters || {}
        saved_filters[filter_name] =
          active_scaffold_session_storage["list_filter"]
        active_scaffold_config.list_filter.user.saved_list_filters = saved_filters
      end
    end

    def load_list_filter
      filter_config = active_scaffold_config.list_filter
      filter_name = params["list_filter"]["load_filter_name"]
      if filter_config.filter_save_class
        active_scaffold_session_storage["list_filter"] =
          filter_config.filter_save_class.load(current_user.id, filter_name)
      else
        saved_filters = active_scaffold_config.list_filter.user.saved_list_filters || {}
        active_scaffold_session_storage["list_filter"] = saved_filters[filter_name]
      end
    end

    def delete_list_filter
      filter_config = active_scaffold_config.list_filter
      filter_name = params["list_filter"]["delete_filter_name"]
      if filter_config.filter_save_class
          filter_config.filter_save_class.delete(current_user.id, filter_name)
      else
        saved_filters = filter_config.user.saved_list_filters || {}
        saved_filters.delete(filter_name)
        active_scaffold_session_storage["list_filter"] = saved_filters[filter_name]
      end
    end

    def clear_list_filter
      active_scaffold_session_storage[:list_filter] = nil?
      active_scaffold_config.list.user.page = nil
    end

    # The default security delegates to ActiveRecordPermissions.
    # You may override the method to customize.
    def list_filter_authorized?
      authorized_for?(:action => :read)
    end
  end
end
