class AddColumnToPassword < ActiveRecord::Migration[6.0]
  def change
    add_column :passwords, :user_id, :integer
  end
end
