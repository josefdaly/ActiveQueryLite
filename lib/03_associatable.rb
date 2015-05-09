require_relative '02_searchable'
require 'active_support/inflector'

# Phase IIIa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    @class_name.constantize
  end

  def table_name
    @class_name.downcase + 's'
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})

    @foreign_key = options[:foreign_key] || "#{name}_id".to_sym
    @class_name = options[:class_name] || name.to_s.singularize.capitalize
    @primary_key = options[:primary_key] || :id
  end


end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})

    @foreign_key = options[:foreign_key] ||
      "#{self_class_name.singularize.downcase}_id".to_sym
    @class_name = options[:class_name] || name.to_s.capitalize.singularize
    @primary_key = options[:primary_key] || :id
  end
end

module Associatable
  # Phase IIIb
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)
    define_method(name) do
      options.model_class.where(id: self.send(options.foreign_key)).first
    end
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self.to_s, options)
    define_method(name) do
      options.model_class.where(options.foreign_key => self.id)
    end
  end

  def assoc_options
    # Wait to implement this in Phase IVa. Modify `belongs_to`, too.
    
  end
end

class SQLObject
  extend Associatable
end
