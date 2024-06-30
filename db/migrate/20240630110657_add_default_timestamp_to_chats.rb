class AddDefaultTimestampToChats < ActiveRecord::Migration[7.0]
  def change
    execute <<-SQL
      ALTER TABLE chats
      MODIFY COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

    SQL
  end
end
