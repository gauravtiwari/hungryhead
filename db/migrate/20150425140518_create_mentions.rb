class CreateMentions < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    create_table :mentions do |t|
      t.belongs_to :mentionable, null: false, polymorphic: true
      t.belongs_to :mentioner, null: false, polymorphic: true
      t.belongs_to :user, index: true, null: false, foreign_key: true
      t.timestamps null: false
    end

    add_index :mentions, [:mentionable_type, :mentionable_id], algorithm: :concurrently
    add_index :mentions, [:mentioner_id, :mentioner_type], algorithm: :concurrently
  end
end
