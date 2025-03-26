FactoryBot.define do
  factory :voice_message do
    user { nil }
    group { nil }
    private_message { nil }
    audio_file { nil }
  end
end
