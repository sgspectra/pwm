class AddColumnsToPassword < ActiveRecord::Migration[6.0]
  def change
    add_column :passwords, :generate, :boolean
    add_column :passwords, :uppercase, :boolean
    add_column :passwords, :lowercase, :boolean
    add_column :passwords, :symbols, :boolean
    add_column :passwords, :digits, :boolean
    add_column :passwords, :length, :string
  end
end
