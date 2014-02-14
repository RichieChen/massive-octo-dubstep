class CreateLogins < ActiveRecord::Migration
  def change
    create_table :logins do |t|
      t.string :username
      t.string :password
      t.integer :counter

      t.timestamps
    end
  end
end
