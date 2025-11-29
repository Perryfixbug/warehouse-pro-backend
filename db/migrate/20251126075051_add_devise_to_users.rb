class AddDeviseToUsers < ActiveRecord::Migration[8.0]
  def change
    rename_column :users, :password_digest, :encrypted_password
    change_column_null :users, :encrypted_password, false, ""
    change_column_default :users, :encrypted_password, ""

    #Unique email
    change_column_null :users, :email, false
    add_index :users, :email, unique: true

    #remember password
    add_column :users, :remember_created_at, :datetime
    remove_column :users, :remember_digest

    #reset
    add_column :users, :reset_password_token, :string
    add_column :users, :reset_password_sent_at, :datetime
    add_index :users, :reset_password_token, unique: true
  end
end
