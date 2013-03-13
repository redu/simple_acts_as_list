require 'active_support'

module SimpleActsAsList::ModelAdditions
  # Provides very simple list's behavior.
  #
  # A minimal implementation could be:
  #
  # class Item
  #   include SimpleActsAsList::ModelAdditions
  #   simple_acts_as_list :scope => :todo_list_id
  # end

  extend ActiveSupport::Concern

  included do
    before_create :update_position
  end

  module ClassMethods
    # Adds methods to consult informations about the list where the element belongs
    #
    # :scope => Attribute that defines the list scope
    def simple_acts_as_list(opts={})
      cattr_accessor :simple_acts_as_list_scope_id
      self.simple_acts_as_list_scope_id = opts[:scope]
    end

    # Scope that returns item's list ordered by position
    def simple_acts_as_list_scope(scope_id)
      self.where(
        "#{self.table_name}.#{self.simple_acts_as_list_scope_id}" => scope_id).
        order("#{self.table_name}.position")
    end
  end

  # Returns +true+ if the item is the last one of the list
  def last_item?
    self.simple_acts_as_list_scope.last == self
  end

  # Returns +true+ if the item is the first one of the list
  def first_item?
    self.simple_acts_as_list_scope.first == self
  end

  # Returns last list item
  def last_item
    self.simple_acts_as_list_scope.last
  end

  # Returns first list item
  def first_item
    self.simple_acts_as_list_scope.first
  end

  # Returns next list item
  #
  # Returns +nil+ if the item is the last one of the list
  def next_item
    index = self.simple_acts_as_list_scope.index(self)
    self.simple_acts_as_list_scope[index + 1]
  end

  # Returns previous list item
  #
  # Returns +nil+ if the item is the first one of the list
  def previous_item
    index = self.simple_acts_as_list_scope.index(self)
    index == 0 ? nil : self.simple_acts_as_list_scope[index - 1]
  end

  # Returns the item with +offset+ position based on current item
  #
  # Example:
  #   @todo = Todo.create
  #   @todo_2 = Todo.create
  #   @todo.item_at_offset(1) # returns @todo_2
  #   @todo_2.item_at_offset(-1) # returns @todo
  #
  def item_at_offset(offset)
    item_index = self.simple_acts_as_list_scope.index(self)
    index = item_index + offset
    index < 0 ? nil : self.simple_acts_as_list_scope[index]
  end

  protected

  # Updates item's position that is being created
  def update_position
    if self.simple_acts_as_list_scope.length == 0
      self.position = 1
    else
      self.position = self.simple_acts_as_list_scope.last.position + 1
    end
  end

  # Auxiliar method to invoke the scope that returns the list
  def simple_acts_as_list_scope
    scope_id = self.send(self.class.simple_acts_as_list_scope_id)
    self.class.simple_acts_as_list_scope(scope_id)
  end
end
