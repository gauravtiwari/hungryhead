class CreateInvestments < ActiveRecord::Migration

  def change

    create_table :investments do |t|

      t.uuid :uuid, null: false, default: 'uuid_generate_v4()'

      t.string :slug, :unique => true, null: false, default: ""

      t.integer :amount, :null => false

      t.string :message

      t.references :user, :null => false
      t.references :idea, :null => false

      t.jsonb :parameters, default: "{}"

      t.timestamps null: false

    end

  end

end
