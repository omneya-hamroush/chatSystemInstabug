class AddDefaultTimestampsToChats < ActiveRecord::Migration[7.0]
  def change
    execute <<-SQL
      ALTER TABLE chats
      MODIFY COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

    SQL
  end
end
