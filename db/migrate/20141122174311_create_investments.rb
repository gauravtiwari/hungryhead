class CreateInvestments < ActiveRecord::Migration

  def change

    create_table :investments do |t|

      t.uuid :uuid, null: false, default: 'uuid_generate_v4()'

      t.integer :amount, :null => false

      t.string :message

      t.references :user, :null => false
      t.references :idea, :null => false

      t.jsonb :parameters, default: "{}"

      t.timestamps null: false

    end

    add_index :investments, :amount, name: "index_investment_angel",  where: "amount < 500 AND amount > 200"
    add_index :investments, :amount, name: "index_investment_vc",  where: "amount < 900 AND amount > 500"

  end

end
