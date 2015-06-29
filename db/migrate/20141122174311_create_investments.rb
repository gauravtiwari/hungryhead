class CreateInvestments < ActiveRecord::Migration
  disable_ddl_transaction!
  def change

    create_table :investments do |t|

      t.uuid :uuid, null: false, default: 'uuid_generate_v4()'

      t.integer :amount, :null => false

      t.string :message

      t.references :user, :null => false
      t.references :idea, :null => false

      t.timestamps null: false

    end

    add_index :investments, :amount, name: "index_investment_angel",  where: "amount < 500 AND amount > 200", algorithm: :concurrently
    add_index :investments, :amount, name: "index_investment_vc",  where: "amount < 900 AND amount > 500", algorithm: :concurrently
    add_index :investments, :user_id, algorithm: :concurrently
    add_index :investments, :idea_id, algorithm: :concurrently
    add_index :investments, :uuid, algorithm: :concurrently
    add_index :investments, [:idea_id, :user_id], unique: true, algorithm: :concurrently

  end

end
