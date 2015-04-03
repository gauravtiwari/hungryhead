class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.references :user, index: true
      t.string :provider
      t.string :uid
      t.string :access_token
      t.string :token_secret
      t.jsonb :parameters 

      t.timestamps null: false
    end
    add_index :authentications, [:uid, :provider, :access_token]
    add_index :authentications, :parameters, using: :gin
  end
end