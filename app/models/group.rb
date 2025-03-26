class Group < ApplicationRecord
    validates :name, presence: true, uniqueness: true
    has_many :group_messages, dependent: :destroy
    has_and_belongs_to_many :users
    has_many :voice_messages, dependent: :destroy
end
