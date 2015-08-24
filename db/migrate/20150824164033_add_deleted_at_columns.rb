class AddDeletedAtColumns < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    add_column :ideas, :deleted_at, :datetime, index: true, algorithm: :concurrently
    add_column :users, :deleted_at, :datetime, index: true, algorithm: :concurrently
    add_column :schools, :deleted_at, :datetime, index: true, algorithm: :concurrently
    add_column :feedbacks, :deleted_at, :datetime, index: true, algorithm: :concurrently
    add_column :events, :deleted_at, :datetime, index: true, algorithm: :concurrently
  end
end
