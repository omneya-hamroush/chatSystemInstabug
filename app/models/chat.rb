class Chat < ApplicationRecord
  belongs_to :application, counter_cache: true
  has_many :messages, dependent: :destroy 

  before_create :set_chat_number

  private

  def set_chat_number
    self.number = application.chats.maximum(:number).to_i + 1
  end
end
