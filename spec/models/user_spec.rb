require 'rails_helper'

RSpec.describe User, type: :model do
  describe "check associations" do
    it { is_expected.to have_many(:group_messages).dependent(:destroy)}
    it { is_expected.to have_and_belong_to_many(:groups)}
    it { is_expected.to have_many(:private_messages).with_foreign_key(:sender_id).class_name('PrivateMessage')}
    it { is_expected.to have_many(:received_messages).with_foreign_key(:receiver_id).class_name('PrivateMessage') }
  end
  describe "check validations" do
    it { is_expected.to validate_presence_of(:name)}
    it { is_expected.to validate_uniqueness_of(:name)}
  end
end
