class CreateShares < ActiveRecord::Migration
  def change
    create_table :shares do |t|
      t.text :body
      t.integer :status
      t.integer :privacy
      t.references :shareable, polymorphic: true
      t.references :user, index: true, foreign_key: true
      t.jsonb :parameters

      t.timestamps null: false
    end
    add_index :shares, [:shareable_id, :shareable_type]
    add_index :shares, :parameters, using: :gin
  end
end
