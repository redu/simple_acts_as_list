require 'active_record'

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3',
                                        :database => ':memory:')

ActiveRecord::Schema.define do
  create_table 'todo_lists', :force => true do |t|
    t.string 'name'
  end

  create_table 'items', :force => true do |t|
    t.string 'name'
    t.integer 'todo_list_id'
    t.integer 'position'
  end
end

class TodoList < ActiveRecord::Base
  has_many :items
end

class Item < ActiveRecord::Base
  include SimpleActsAsList::ModelAdditions
  simple_acts_as_list :scope => :todo_list_id

  belongs_to :todo_list
end
