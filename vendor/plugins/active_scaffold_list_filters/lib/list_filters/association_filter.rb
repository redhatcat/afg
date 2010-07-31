class ListFilters::AssociationFilter < ActiveScaffold::DataStructures::ListFilter

  # Return a list of conditions based on the params
  def find_options
    begin
      association = association_class
      options = {}
      options[:include] = association_name
      clean_params = params.reject{ |p| p == 'NOT' }
      if params.include? 'NOT'
        if not clean_params.empty?
          options[:conditions] = ["#{association.table_name}.id NOT IN (?)",
            clean_params]
        end
      else
        options[:conditions] = ["#{association.table_name}.id IN (?)", clean_params]
      end

      return options
    end unless params.nil? || params.empty?
  end

  def verbose
    begin
      clean_params = params.reject{ |p| p == 'NOT' }
      if not clean_params.empty?
        ar_class = association_class
        associated_values = ar_class.find(clean_params).sort {|a,b| a.to_label <=> b.to_label }
        verbose_values = associated_values.collect{|av| av.to_label}.join(", ")
        if params.include? 'NOT'
          return "NOT #{verbose_values}"
        else
          return verbose_values
        end
      end
    end unless params.nil? || params.empty?
    nil
  end

  def association_name
    @options[:association] || @name
  end

  def association_class
    association = @core.model.reflect_on_association(association_name)
    association.klass
  end

  def associated_values
    values = association_class.find(:all).collect{ |obj|
      [obj.id, obj.to_label]
    }.sort{ |a, b|
      a[1] <=> b[1]
    }
    [['NOT', 'Exclude selections']] + values
  end
end
