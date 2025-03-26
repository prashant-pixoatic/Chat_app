class CreateGroupsUsersJoinTable < ActiveRecord::Migration[8.0]
  def change
    create_table :groups_users, id: false do |t|
      t.references :user, foreign_key: true
      t.references :group, foreign_key: true
    
    end
    
  end
end
