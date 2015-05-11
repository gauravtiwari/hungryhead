class CreateBadges < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    create_table :badges do |t|
      t.references :badgeable, polymorphic: true, null: false
      t.string :badge_name, null: false, default: ""
      t.integer :badge_point, null: false, default: ""
      t.string :event, null: false, default: ""
      t.string :description

      t.timestamps null: false
    end
    add_index :badges, :badge_name, algorithm: :concurrently
    add_index :badges, [:badgeable_id, :badgeable_type], algorithm: :concurrently
  end
end
