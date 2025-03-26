# require 'rails_helper'

# RSpec.describe HomeController, type: :controller do
#   include Devise::Test::ControllerHelpers

#   let!(:user) { FactoryBot.create(:user) }
#   let!(:user1) { FactoryBot.create(:user) }
#   let!(:group) { FactoryBot.create(:group) }

#   before do
#     sign_in user
#   end

#   describe "GET #index" do
#     it "should show all users" do
#       get :index
#       expect(response.body).to include(user.name)
#       expect(response.body).to include(user1.name)
#     end

#     it "should show current user groups" do
#       get :index
#       expect(response.body).to include(group.name)
#     end
#   end
# end
