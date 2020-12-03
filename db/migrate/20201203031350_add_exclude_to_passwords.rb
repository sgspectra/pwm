class AddExcludeToPasswords < ActiveRecord::Migration[6.0]
  def change
    add_column :passwords, :exculde, :string
  end
end
