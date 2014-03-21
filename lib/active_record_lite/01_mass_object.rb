# deprecated for Rails 4
require_relative '00_attr_accessor_object.rb'

class MassObject < AttrAccessorObject
  # def self.my_attr_accessible(*new_attributes)
#     # ...
#   end

  def self.attributes
    raise "must not call #attributes on MassObject directly" if self == MassObject
    @attributes ||= {}
  end

  def initialize(params = {})
    params.each do |key, value|
      self.class.my_attr_accessor key
      self.send("#{key}=", value)
    end
  end
end
