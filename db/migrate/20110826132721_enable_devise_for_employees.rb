class EnableDeviseForEmployees < ActiveRecord::Migration
  def up

    change_table(:employees) do |t|
      t.string :encrypted_password, :null => false, :default => ""
      t.recoverable
      t.rememberable
      t.trackable
    end

    change_column :employees, :email, :string, :null => false, :default => ""

    add_index :employees, :email,                :unique => true
    add_index :employees, :reset_password_token, :unique => true
  end

  def down
    change_table(:employees) do |t|
      t.remove :encrypted_password
      t.remove :reset_password_token
      t.remove :reset_password_sent_at
      t.remove :remember_created_at
      t.remove :sign_in_count
      t.remove :current_sign_in_at
      t.remove :last_sign_in_at
      t.remove :current_sign_in_ip
      t.remove :last_sign_in_ip
    end

    change_column :employees, :email, :string, :null => true, :default => nil

    remove_index :employees, :email
  end

end