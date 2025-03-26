class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, uniqueness: true
  has_many :group_messages, dependent: :destroy
  has_and_belongs_to_many :groups
  has_many :private_messages, foreign_key: :sender_id, class_name: 'PrivateMessage'
  has_many :received_messages, foreign_key: :receiver_id, class_name: 'PrivateMessage'
  has_many :voice_messages, foreign_key: :sender_id, class_name: "VoiceMessage", dependent: :destroy
  has_many :received_voice_messages, foreign_key: :receiver_id, class_name: "VoiceMessage", dependent: :destroy
end
