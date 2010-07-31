class ListFilters::FieldSetFilter < ActiveScaffold::DataStructures::ListFilter

  def find_options
    begin
      options = {}
      clean_params = params.reject{ |p| p == 'NOT' }
      if params.include? 'NOT'
        if not clean_params.empty?
          options[:conditions] = ["#{field_name.to_s} NOT IN (?)", clean_params]
        end
      else
        options[:conditions] = ["#{field_name.to_s} IN (?)", clean_params]
      end
      return options
    end unless params.blank?
  end

  def verbose
    clean_params = params.reject{ |p| p == 'NOT' }
    if not clean_params.empty?
      if params.include? 'NOT'
        return "NOT " + clean_params.join(", ")
      else
        return clean_params.join(", ")
      end
    end
    nil
  end

  def field_name
    @name
  end

  def values
    if options[:values]
      ['NOT'] + options[:values]
    else
      []
    end
  end

end
