require 'rails_helper'

RSpec.describe Group, type: :model do
  describe "Check associations" do
    it { is_expected.to have_many(:group_messages).dependent(:destroy)}
    it { is_expected.to have_and_belong_to_many(:users)}
  end
  describe "check validations" do
    it { is_expected.to validate_presence_of(:name)}
    it { is_expected.to validate_uniqueness_of(:name)}
  end
end
