class AddStrengthToPassword < ActiveRecord::Migration[6.0]
  def change
    add_column :passwords, :strength, :string
  end
end
