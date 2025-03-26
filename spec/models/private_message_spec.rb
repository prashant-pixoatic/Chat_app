require 'rails_helper'

RSpec.describe PrivateMessage, type: :model do
  describe "check associations" do
    it { is_expected.to belong_to(:sender).class_name('User')}
    it { is_expected.to belong_to(:receiver).class_name('User')}
  end
  describe "check validations" do
    it { is_expected.to validate_presence_of(:content)}
  end
end
