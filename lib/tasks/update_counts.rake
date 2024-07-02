
namespace :update_counts do
  desc "Update chats_count in Application table and messages_count in Chat table"
  task update: :environment do
    begin
      Rails.logger.info "Starting update_counts rake task at #{Time.now}"

      # Update chats_count in Application table
      sql_chats_count = <<-SQL
        UPDATE applications AS app
        SET chats_count = (
          SELECT COUNT(*)
          FROM chats AS c
          WHERE c.application_id = app.id
        )
      SQL
      ActiveRecord::Base.connection.execute(sql_chats_count)

      Rails.logger.info "Updated chats_count in Application table"

      # Update messages_count in Chat table
      sql_messages_count = <<-SQL
        UPDATE chats AS c
        SET messages_count = (
          SELECT COUNT(*)
          FROM messages AS m
          WHERE m.chat_id = c.id
        )
      SQL
      ActiveRecord::Base.connection.execute(sql_messages_count)

      Rails.logger.info "Updated messages_count in Chat table"

      Rails.logger.info "update_counts rake task completed successfully at #{Time.now}"
    rescue StandardError => e
      Rails.logger.error "Error in update_counts rake task: #{e.message}"
      raise e
    end
  end
end
