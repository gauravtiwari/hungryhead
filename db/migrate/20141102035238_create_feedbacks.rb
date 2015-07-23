class CreateFeedbacks < ActiveRecord::Migration

  disable_ddl_transaction!

  def change
    create_table :feedbacks do |t|

      t.uuid :uuid, null: false, default: 'uuid_generate_v4()'

      t.text :body, :null => false, default: ""

      t.references :idea, :null => false
      t.references :user, :null => false

      t.string :cached_category_list

      t.integer :status, default: 0, null: false

      t.integer :badge, default: 0, null: false

      t.timestamps null: false
    end

    add_index :feedbacks, :user_id, algorithm: :concurrently
    # Add partial where indexes for postgresql
    add_index :feedbacks, :status, name: "index_feedback_status", where: "status = 1", algorithm: :concurrently

    add_index :feedbacks, [:status, :badge], algorithm: :concurrently

    add_index :feedbacks, :badge, name: "index_feedback_helpful", where: "badge = 1", algorithm: :concurrently
    add_index :feedbacks, :badge, name: "index_feedback_unhelpful", where: "badge = 2", algorithm: :concurrently
    add_index :feedbacks, :badge, name: "index_feedback_irrelevant", where: "badge = 3", algorithm: :concurrently

    add_index :feedbacks, [:user_id, :idea_id], unique: true, algorithm: :concurrently

    add_index :feedbacks, :uuid, algorithm: :concurrently
    add_index :feedbacks, :idea_id, algorithm: :concurrently
  end

end
