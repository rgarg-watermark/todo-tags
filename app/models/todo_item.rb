class TodoItem
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Enum
  include Mongoid::Paranoia
  field :title, type: String
  field :description, type: String
  enum :status, [:not_start, :start, :finish], default: :not_start
  field :tags, type: Array, default: []

  validates_presence_of :title

end
