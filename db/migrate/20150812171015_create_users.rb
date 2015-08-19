class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string        :name,                null: false, limit: 50
      t.string        :email,               null: false, limit: 100

      t.string        :crypted_password,    null: false
      t.string        :password_salt,       null: false

      t.string        :persistence_token,   null: false

      t.integer       :login_count,         null: false, default: 0
      t.integer       :failed_login_count,  null: false, default: 0
      t.datetime      :current_login_at
      t.datetime      :last_login_at

      t.timestamps null: false
    end

    add_index :users, [:email], unique: true
  end
end
