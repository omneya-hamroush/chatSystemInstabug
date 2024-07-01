class Message < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  belongs_to :chat, counter_cache: true

  before_create :set_message_number
  index_name "messages_#{Rails.env}"

  settings do
    mappings dynamic: false do
      indexes :chat_id, type: :integer
      indexes :content, type: :text
    end
  end
  private

  def set_message_number
    self.number = chat.messages.maximum(:number).to_i + 1
  end
end
