class AddSenderAndReceiverToPrivateMessages < ActiveRecord::Migration[8.0]
  def change
    add_column :private_messages, :sender_id, :integer, null: false
    add_column :private_messages, :receiver_id, :integer, null: false

    add_index :private_messages, :sender_id
    add_index :private_messages, :receiver_id

    add_foreign_key :private_messages, :users, column: :sender_id
    add_foreign_key :private_messages, :users, column: :receiver_id
  end
end
