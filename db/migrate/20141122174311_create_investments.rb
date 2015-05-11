class CreateInvestments < ActiveRecord::Migration
  def change
    create_table :investments do |t|

      t.integer :amount, :null => false
      t.string :note

      t.references :user, :null => false
      t.references :idea, :null => false

      t.jsonb :parameters, default: "{}"
      t.timestamps null: false

    end
  end
end
