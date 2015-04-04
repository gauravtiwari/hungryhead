class CreateMentors < ActiveRecord::Migration
  def change
    create_table :mentors do |t|
      t.string :cached_roles_list
      t.integer :ideas_count, default: 0
      t.timestamps null: false
    end
  end
end
