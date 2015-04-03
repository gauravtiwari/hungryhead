class AddMessagesCountToMailboxerConversations < ActiveRecord::Migration
  def change
    add_column :mailboxer_conversations, :messages_count, :integer, default: 0
  end
end
