class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :username
      t.date :dob
      t.string :first_name
      t.string :last_name
      t.string :master_password_dgst

      t.timestamps
    end
  end
end
