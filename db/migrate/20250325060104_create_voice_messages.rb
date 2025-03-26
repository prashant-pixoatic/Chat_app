class CreateVoiceMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :voice_messages do |t|
      t.references :group, foreign_key: true
      t.integer :sender_id, null: false
      t.integer :receiver_id, null: true

      t.timestamps
    end

    add_foreign_key :voice_messages, :users, column: :sender_id
    add_foreign_key :voice_messages, :users, column: :receiver_id

    add_index :voice_messages, :sender_id
    add_index :voice_messages, :receiver_id
  end
end
