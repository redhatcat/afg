module ActiveScaffold::Config
  class ListFilter < Base
    self.crud_type = :read
    attr_accessor :filter_save_class

    def initialize(core_config)
      @core = core_config

      # originates here
      @list_filters = ActiveScaffold::DataStructures::ListFilters.new()
      @filter_save_class = nil
    end

    # global level configuration
    # --------------------------
    # the ActionLink for this action
    cattr_accessor :link
    @@link = ActiveScaffold::DataStructures::ActionLink.new('list_filter', :label => :filter, :security_method => :list_filter_authorized?)

    # instance-level configuration
    # ----------------------------
    attr_writer :link
    def link
      if @list_filters.length > 0
        self.class.link.clone
      end
    end

    # provides access to the list of columns specifically meant for the Table to use
    def columns
      self.columns = @core.columns._inheritable unless @columns # lazy evaluation
      @columns
    end
    def columns=(val)
      @columns = ActiveScaffold::DataStructures::ActionColumns.new(*val)
      @columns.action = self
    end

    def get_column(col)
      @columns.detect{|c| col.to_sym == c.name.to_sym }
    end

    # provides access to the list of filters
    attr_reader :filters
    def filters
      @list_filters
    end

    # Add a list filter
    def add(filter_type, filter_name, options = {}, defaults = {})
      @list_filters.add(filter_type, filter_name, @core, options, defaults)
    end

    # Use specified class/module to save filters for users
    # Class/Module must support these public methods:
    #  list(user_id) => filter_names
    #  save(user_id, name, params_hash) => nil
    #  load(user_id, name) => params_hash
    #  delete(user_id, name) => nil
    def save_with(save_class)
      @filter_save_class = save_class
    end

    def get_filter_names(current_user)
      if filter_save_class
        filter_save_class.list(current_user.id)
      else
        user.saved_list_filters.keys.sort
      end
    end

    class UserSettings < UserSettings
      def saved_list_filters
        @session['saved_list_filters']
      end

      def saved_list_filters=(value=[])
        @session['saved_list_filters'] = value
      end
    end
  end
end
