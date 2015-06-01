class AddSlugToFeedbacks < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    add_column :feedbacks, :slug, :string, null: false, default: ""
    add_index :feedbacks, :slug, unique: true, algorithm: :concurrently
  end
end
