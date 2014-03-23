require_relative '03_searchable'
require 'active_support/inflector'

# Phase IVa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key,
  )

  def model_class
    model_name = ActiveSupport::Inflector.singularize(class_name.to_s)
    ActiveSupport::Inflector.camelcase(model_name)
  end

  def table_name
    table_name = ActiveSupport::Inflector.pluralize(class_name.to_s)
    ActiveSupport::Inflector.underscore(table_name)
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    # ...
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    # ...
  end
end

module Associatable
  # Phase IVb
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)
    define_mathod(name) do
      class_name = options[:class_name] || send(model_class)
      foreign_key = options[:foreign_key] || { send(table_name) + "_id"}.to_sym
      primary_key = options[:primary_key] || :id
    end
  end

  def has_many(name, options = {})
    # ...
  end

  def assoc_options
    # Wait to implement this in Phase V. Modify `belongs_to`, too.
  end
end

class SQLObject
  extend Associatable

end
