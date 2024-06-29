class Application < ApplicationRecord
    before_create :generate_token
    has_many :chats, dependent: :destroy 

    validates :name, presence: true
    validates :token, uniqueness: true
  
    private
  
    def generate_token
      loop do
        self.token = SecureRandom.hex(10)
        break unless Application.exists?(token: token)
      end
    end
end
