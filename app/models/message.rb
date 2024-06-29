class Message < ApplicationRecord
  belongs_to :chat, counter_cache: true

  before_create :set_message_number

  private

  def set_message_number
    self.number = chat.messages.maximum(:number).to_i + 1
  end
end
