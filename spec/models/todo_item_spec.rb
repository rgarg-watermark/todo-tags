require 'rails_helper'

RSpec.describe TodoItem, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  it "is valid with a title" do
	  todo_item = TodoItem.new(title: 'meeting')
	  expect(todo_item).to be_valid
	end
  it "is not valid without a title" do
	  todo_item = TodoItem.new(title: nil)
	  expect(todo_item).to_not be_valid
	end
end
