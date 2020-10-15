require 'rails_helper'

RSpec.describe "TodoItems", type: :request do
	context 'GET /todo_items' do
		before(:each) do

			create(:todo_item, title: 'meeting at 10 AM', description: 'Sprint Planning meeting', tags: ['work'])
			create(:todo_item, title: 'submit assignment', description: 'Submit practice assignment', tags: ['assignment', 'work'])
		end
		it 'returns all todo items' do
			get '/todo_items.json'

			expect(response).to have_http_status(:success)
			expect(JSON.parse(response.body).size).to eq(2)
		end
		it 'returns todo items records for specific tag' do
			get '/todo_items.json?tags=assignment'

			expect(response).to have_http_status(:success)
			expect(JSON.parse(response.body).size).to eq(1)
		end
	end

	context 'POST /todo_items' do
		it 'create a new todo item' do
			expect{post '/todo_items.json', {todo_item: {title: 'Client Call', tags: ['call', 'work']}}}.to change {TodoItem.count}.from(0).to(1)

			expect(response).to have_http_status(:created)
		end
		it 'not create todo item without title' do
			post '/todo_items.json', {todo_item: {title: '', tags: ['call', 'work']}}

			expect(response).to have_http_status(:unprocessable_entity)
		end
	end

	context 'PUT /todo_items/:id' do
		let!(:todo_item) { create(:todo_item, title: 'meeting at 10 AM')}
		it 'update the exiting todo item with given todo item id' do			
			put "/todo_items/#{todo_item.id}.json", {todo_item: {title: 'Client Call'}}

			expect(response).to have_http_status(:success)
		end

		it 'does not update the todo item for non existing todo item' do			
			expect{put "/todo_items/12.json"}.to raise_error(Mongoid::Errors::DocumentNotFound)
		end
	end

	context 'GET /todo_items/:id' do
		let!(:todo_item) { create(:todo_item, title: 'meeting at 10 AM')}
		it 'show a todo item detail for existing todo item' do			
			get "/todo_items/#{todo_item.id}.json"

			expect(response).to have_http_status(:success)
		end
		
		it 'does not show todo item detail for non existing todo item' do			
			expect{get "/todo_items/12.json"}.to raise_error(Mongoid::Errors::DocumentNotFound)
		end
	end

	context 'DELETE /todo_items/:id' do
		let!(:todo_item) { create(:todo_item, title: 'meeting at 10 AM')}
		it 'delete a todo item' do			
			expect{delete "/todo_items/#{todo_item.id}.json"}.to change {TodoItem.count}.from(1).to(0)

			expect(response).to have_http_status(:no_content)
		end
	end

	context 'RESTORE deleted /todo_items/:id/restore' do
		let!(:todo_item) { create(:todo_item, title: 'meeting at 10 AM')}
		it 'restore deleted a todo item' do			
			expect{delete "/todo_items/#{todo_item.id}.json"}.to change {TodoItem.count}.from(1).to(0)
			expect{put "/todo_items/#{todo_item.id}/restore.json"}.to change {TodoItem.count}.from(0).to(1)

			expect(response).to have_http_status(:ok)
		end
	end
end
