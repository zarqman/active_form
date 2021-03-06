require 'active_support/inflector'
require 'active_support/core_ext/hash/except'
require 'active_model'

class ActiveForm
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend  ActiveModel::Translation
  include ActiveModel::Validations::Callbacks

  def persisted?; false; end

  def initialize(attributes = nil)
    # Mass Assignment implementation
    if attributes
      attributes.each do |key, value|
        self.public_send("#{key}=", value)
      end
    end
    yield self if block_given?
  end
  
  def [](key)
    instance_variable_get("@#{key}")
  end
  
  def []=(key, value)
    instance_variable_set("@#{key}", value)
  end

  def attributes
    h = {}.with_indifferent_access
    instance_variable_names.map do |iv|
      unless ['@validation_context', '@errors'].include? iv
        h[iv.sub('@','')] = instance_variable_get iv
      end
    end
    h
  end
  
  def method_missing(method_id, *params)
    # Implement _before_type_cast accessors
    if md = /_before_type_cast$/.match(method_id.to_s)
      attr_name = md.pre_match
      return self[attr_name] if self.respond_to?(attr_name)
    end
    super
  end

  def new_record?
    true
  end

  def id
    nil
  end

  if defined?(Rails)
    def logger
      Rails.logger
    end
  end

  def raise_not_implemented_error(*params)
    self.class.raise_not_implemented_error(params)
  end
  
  alias save raise_not_implemented_error
  alias save! raise_not_implemented_error
  alias update_attribute raise_not_implemented_error
  alias update_attributes raise_not_implemented_error
  alias save valid?
  alias save! raise_not_implemented_error
  alias update_attribute raise_not_implemented_error
  alias update_attributes raise_not_implemented_error
  
  class <<self
    def raise_not_implemented_error(*params)
      raise NotImplementedError
    end
    
    alias create raise_not_implemented_error
    alias create! raise_not_implemented_error
    alias validates_acceptance_of raise_not_implemented_error
    alias validates_uniqueness_of raise_not_implemented_error
    alias validates_associated raise_not_implemented_error
    alias validates_on_create raise_not_implemented_error
    alias validates_on_update raise_not_implemented_error
    alias save_with_validation raise_not_implemented_error
  end
end
