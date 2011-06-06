class CreateUserSessions < ActiveRecord::Migration
  def self.up
    create_table :user_sessions do |t|
      t.string :access_token
      t.integer :expires
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :user_sessions
  end
end
