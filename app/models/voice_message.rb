class VoiceMessage < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User", optional: true
  belongs_to :group, optional: true
  has_one_attached :audio_file
  validates :audio_file, presence: true
end
