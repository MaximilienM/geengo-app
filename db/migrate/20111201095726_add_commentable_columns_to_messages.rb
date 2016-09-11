class AddCommentableColumnsToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :commentable_type, :string
    add_column :messages, :commentable_id, :integer
  end
end
