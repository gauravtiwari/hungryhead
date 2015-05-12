class CreateFeedbacks < ActiveRecord::Migration

  disable_ddl_transaction!

  def change
    create_table :feedbacks do |t|
      t.text :body, :null => false, default: ""

      t.references :idea, :null => false
      t.references :user, :null => false

      t.integer :score, null: false, default: 0
      t.integer :views, null: false, default: 0

      t.string :cached_tag_list

      t.integer :status, default: 0, null: false
      t.integer :badge, default: 0, null: false

      t.jsonb :parameters, default: "{}"

      t.timestamps null: false
    end
    add_index :feedbacks, :user_id, algorithm: :concurrently

    add_index :feedbacks, :score, algorithm: :concurrently
    add_index :feedbacks, :views, algorithm: :concurrently

    add_index :feedbacks, :status, algorithm: :concurrently
    add_index :feedbacks, :badge, algorithm: :concurrently

    add_index :feedbacks, :parameters, using: :gin
    add_index :feedbacks, :idea_id, algorithm: :concurrently
  end

end
