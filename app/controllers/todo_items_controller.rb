class TodoItemsController < ApplicationController
  before_action :set_todo_item, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token

  # GET /todo_items
  # GET /todo_items.json
  # Find all todo items with or without tags with pagination (per page set to 5 by default)
  def index
    if params[:tags].present?
      @todo_items = TodoItem.where(tags: { '$in': [params[:tags]]}).order_by(created_at: :desc).page params[:page]
    else
      @todo_items = TodoItem.order_by(created_at: :desc).page params[:page]
    end
  end

  # GET /todo_items/1
  # GET /todo_items/1.json
  def show
  end

  # POST /todo_items
  # POST /todo_items.json
  # Create Todo Item
  # Request Params:
    # {
    #   "todo_item": {
    #     "title": "new meeting"
    #   }
    # }
  def create
    @todo_item = TodoItem.new(todo_item_params)

    respond_to do |format|
      if @todo_item.save
        format.html { redirect_to @todo_item, notice: 'Todo item was successfully created.' }
        format.json { render :show, status: :created, location: @todo_item }
      else
        format.html { render :new }
        format.json { render json: @todo_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /todo_items/1
  # PATCH/PUT /todo_items/1.json
  # Modify todo item
  # Mark todo item status as start, finish or not start
  # Update todo with tags
  def update
    respond_to do |format|
      if @todo_item.update(todo_item_params)
        format.html { redirect_to @todo_item, notice: 'Todo item was successfully updated.' }
        format.json { render :show, status: :ok, location: @todo_item }
      else
        format.html { render :edit }
        format.json { render json: @todo_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /todo_items/1
  # DELETE /todo_items/1.json
  # delete todo item
  def destroy
    @todo_item.destroy
    respond_to do |format|
      format.html { redirect_to todo_items_url, notice: 'TodoItem was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # PATCH/PUT /todo_items/1/restore
  # PATCH/PUT /todo_items/1/restore.json
  # undo deleted todo item
  def restore
    @todo_item = TodoItem.unscoped.find(params[:id])
    respond_to do |format|
      if @todo_item.restore
        format.html { redirect_to @todo_item, notice: 'Todo item was successfully restored.' }
        format.json { render :show, status: :ok, location: @todo_item }
      else
        format.html { render :edit }
        format.json { render json: @todo_item.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_todo_item
      @todo_item = TodoItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def todo_item_params
      params.require(:todo_item).permit(:title, :description, :status, :tags, tags: [])
    end
end
