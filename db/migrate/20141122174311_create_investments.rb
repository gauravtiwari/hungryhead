class CreateInvestments < ActiveRecord::Migration
  def change
    create_table :investments do |t|
      t.integer :amount, :null => false
      t.string :note, :null => false
      t.integer :user_id, :null => false
      t.integer :idea_id, :null => false
      t.jsonb :parameters, default: "{}"
      t.timestamps null: false
    end
    add_index :investments, :parameters, using: :gin
  end
end
