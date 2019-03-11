class BaseDescriptor
  attr_accessor :prop

  def get(obj, clazz)
    raise "Method Not Implemented"
  end

  def set(obj, val)
    raise "Method Not Implemented"
  end

  def delete(obj)
    raise "Method Not Implemented"
  end
end

module Describable
  def self.included(cls)
    puts "Including #{cls}"
    cls.extend(ClassMethods)
  end
  module ClassMethods
    def field(property, descriptor)
      instance_eval do
        descriptor.prop = property
        define_method :"#{property}" do
          descriptor.get(self, self.class)
        end
        define_method :"#{property}=" do |value|
          descriptor.set(self, value)
        end
      end
    end
  end
end



class ValidatorRequired 
  attr_reader :error

  def initialize
    @error = nil
  end

  def validate(val)
    @error = nil
    if val.nil? or val == "" 
      @error = "is required"
    end
    @error.nil?
  end
end

class ValidatedField < BaseDescriptor

  def initialize(label, validators=[])
    @_label = label
    @_validators = validators
    @_val = nil
    @_errors = []
  end

  def errors
    @_errors
  end

  def data
    @_val
  end

  def set(obj, val)
    @_errors = []
    @_val = val
    @_validators.each do |v|
      unless v.validate(val)
        @_errors << "#{@_label} #{v.error}"
      end
    end
  end

  def get(obj, clazz)
    self
  end
end

class FormField < ValidatedField
  def label
    "<label>#{@_label}</label>"
  end

  def to_s
    "<input type=\"text\" name=\"#{prop}\" value=\"#{@_val}\" />"
  end
end

class Thing
  include Describable
  field :name, ValidatedField.new('Name', [ValidatorRequired.new])
end


class BaseForm
  def initialize
    @_errors = []
  end

  def errors
    @_errors
  end

  def submit(params)
    @_errors = []
    params.each do |key, val|
      prop = send(:"#{key}")
      send(:"#{key}=", val)
      if prop.errors.length > 0 
        @_errors += prop.errors
      end
    end
  end

  def valid?
    errors.length == 0
  end
end

class ThingForm < BaseForm
  include Describable

  field :name, FormField.new('Name', [ValidatorRequired.new])
  field :age, FormField.new('Age', [ValidatorRequired.new])
end

t = Thing.new
t.name = "Filip"
puts t.name.data
t.name = ""
puts t.name.errors

puts
puts "=" * 50
puts

t = ThingForm.new
t.submit({"name" => "Filip", "age" => ""})
unless t.valid?
  puts t.errors
end
puts t.name.data
puts t.age.data
