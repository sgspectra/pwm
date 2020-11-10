class CreatePasswords < ActiveRecord::Migration[6.0]
  def change
    create_table :passwords do |t|
      t.string :login
      t.string :password
      t.string :site

      t.timestamps
    end
  end
end
