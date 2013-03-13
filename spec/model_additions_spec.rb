require 'spec_helper'

describe SimpleActsAsList::ModelAdditions do
  context ".create" do
    context "without position" do
      context "and the list is empty" do
        let(:todo_list) { create_todo_list(:qtt_items => 0) }
        let(:item) do
          Item.create(:name => "Item", :todo_list => todo_list)
        end

        it "should set the position to 1" do
          item.reload
          item.position.should_not be_nil
          item.position.should == 1
        end
      end

      context "and the list is not empty" do
        let(:todo_list) do
          create_todo_list(:qtt_items => 3)
        end
        let(:item) do
          Item.create(:name => "Item", :todo_list => todo_list)
        end

        it "should set the position to 4" do
          item.reload
          item.position.should_not be_nil
          item.position.should == 4
        end
      end
    end
  end


  context "list methods" do
    let(:todo_list) { create_todo_list(:qtt_items => 3) }

    context "responders" do
      let(:item) { Item.new(:name => "Item") }

      [:position, :last_item?, :first_item?, :last_item, :first_item,
       :next_item, :previous_item].each do |method|
        it "should respond to #{method}"  do
          item.should respond_to(method)
        end
       end
    end

    context "#last_item?" do
      it "should return true when the item is the last" do
        last = todo_list.items.last
        last.should be_last_item
      end

      it "should return false when the item is not the last" do
        first = todo_list.items.first
        first.should_not be_last_item

        middle = todo_list.items[1]
        middle.should_not be_last_item
      end
    end

    context "#first_item?" do
      it "should return true when the item is the first" do
        first = todo_list.items.first
        first.should be_first_item
      end

      it "should return false when the item is not the first" do
        last = todo_list.items.last
        last.should_not be_first_item

        middle = todo_list.items[1]
        middle.should_not be_first_item
      end
    end

    context "#last_item" do
      it "should return the last item of the list" do
        item = todo_list.items.first
        item.last_item.should == todo_list.items.last
      end
    end

    context "#first_item" do
      it "should return the first item of the list" do
        item = todo_list.items.last
        item.first_item.should == todo_list.items.first
      end
    end

    context "#next_item" do
      it "should return the next item of the list" do
        first = todo_list.items.first
        first.next_item.should == todo_list.items[1]

        item = todo_list.items[1]
        item.next_item.should == todo_list.items[2]
      end

      it "should return nil if it is the last item of the list" do
        last = todo_list.items.last
        last.next_item.should be_nil
      end
    end

    context "#previous_item" do
      it "should return the previous item of the list" do
        last = todo_list.items.last
        length = todo_list.items.length
        last.previous_item.should == todo_list.items[length - 2]

        item = todo_list.items[1]
        item.previous_item.should == todo_list.items[0]
      end

      it "should return nil if it is the first item of the list" do
        first = todo_list.items.first
        first.previous_item.should be_nil
      end
    end

    context "#item_at_offset" do
      it "should return the item with specified negative offset" do
        item = todo_list.items.last
        length = todo_list.items.length
        item.item_at_offset(-2).should ==
          todo_list.items[length - 3]
      end

      it "should return the item with specified positive offset" do
        item = todo_list.items.first
        length = todo_list.items.length
        item.item_at_offset(2).should ==
          todo_list.items[2]
      end

      it "should return nil if can't find the item with neg specified offset" do
        item = todo_list.items.first
        item.item_at_offset(-1).should be_nil
      end

      it "should return nil if can't find the item with pos specified offset" do
        item = todo_list.items.last
        item.item_at_offset(2).should be_nil
      end
    end
  end

  private

  def create_todo_list(opts={})
    qtt_items = opts[:qtt_items] || 1

    todo_list = TodoList.create(:name => "My Todo List")
    (1..qtt_items).each {|i| todo_list.items << Item.new(:name => "Item #{i}") }
    todo_list
  end
end
