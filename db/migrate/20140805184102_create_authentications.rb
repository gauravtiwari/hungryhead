class CreateAuthentications < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    create_table :authentications do |t|
      t.references :user, index: true, null: false
      t.string :provider
      t.string :uid
      t.string :access_token
      t.string :token_secret
      t.jsonb :parameters

      t.timestamps null: false
    end
    add_index :authentications, [:uid], algorithm: :concurrently
    add_index :authentications, [:uid, :provider, :access_token], unique: true, algorithm: :concurrently
    add_index :authentications, [:provider], algorithm: :concurrently
    add_index :authentications, [:access_token], algorithm: :concurrently
  end
end