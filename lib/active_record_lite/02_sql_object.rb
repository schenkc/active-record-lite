require_relative 'db_connection'
require_relative '01_mass_object'
require 'active_support/inflector'

class MassObject

  def self.parse_all(results)
    results.map do |result|
      self.new(result)
    end
  end

end

class SQLObject < MassObject
  def self.columns
    if @columns.nil?
      @columns = DBConnection.execute2("SELECT * FROM #{table_name} LIMIT 0")
      @columns = @columns.first.map(&:to_sym)
      @columns.each do |col|
        define_method(col) do
          self.attributes[col]
        end
        define_method("#{col}=") do |val|
          self.attributes[col] = val
        end
      end
      @columns
    else
      @columns
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    if self == Human
      'humans'
    else
      table_name = ActiveSupport::Inflector.pluralize(self.to_s)
      ActiveSupport::Inflector.underscore(table_name)
    end
  end

  def self.all
    results = DBConnection.execute(<<-SQL)
    SELECT
      #{self.table_name}.*
    FROM
      #{self.table_name}
    SQL
    self.parse_all(results)
  end

  def self.find(id)
    results = DBConnection.execute(<<-SQL, id)
    SELECT
      #{self.table_name}.*
    FROM
      #{self.table_name}
    WHERE
      #{self.table_name}.id = ?
    LIMIT 1
    SQL
    self.parse_all(results)
  end

  def attributes
    @attributes ||= {}
  end

  def insert
    # ...
  end

  def initialize(params) # params is a signle hash
    columns = self.class.columns
    params.each do |attr_name, value|
      attr_name = attr_name.to_sym
      raise "unknown attribute '#{attr_name}'" unless columns.include?(attr_name)
      self.send("#{attr_name}=", value)
    end
  end

  def save
    # ...
  end

  def update
    # ...
  end

  def attribute_values
    # ...
  end
end
