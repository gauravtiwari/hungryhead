class CreateSchoolAdmins < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    create_table :school_admins do |t|
      t.references :user, index: true, foreign_key: true
      t.references :school, index: true, foreign_key: true
      t.boolean :active, index: true

      t.timestamps null: false
    end

    add_index :school_admins, [:user_id, :school_id], unique: true, algorithm: :concurrently
  end
end
