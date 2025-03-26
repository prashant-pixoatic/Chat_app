require 'rails_helper'

RSpec.describe GroupMessage, type: :model do
  describe "check associations" do
    it { is_expected.to belong_to(:user)}
    it { is_expected.to belong_to(:group)}
  end
end
