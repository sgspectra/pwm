class FixColumnName < ActiveRecord::Migration[6.0]
  def change
    rename_column :passwords, :exculde, :exclude
  end
end
