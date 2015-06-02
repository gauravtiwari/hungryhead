class CreatePosts < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    create_table :posts do |t|

      t.uuid :uuid, null: false, default: 'uuid_generate_v4()'

      t.string :title, null: false, default: ""
      t.text :body, null: false, default: ""

      t.integer :status
      t.belongs_to :user, foreign_key: true, null: false

      t.timestamps null: false

    end

    add_index :posts, :status, algorithm: :concurrently
    add_index :posts, :user_id, algorithm: :concurrently
    add_index :posts, :uuid, unique: true, algorithm: :concurrently

  end

end
