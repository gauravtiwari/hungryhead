class CreateInstitutions < ActiveRecord::Migration
  def change
    create_table :institutions do |t|

      t.timestamps null: false
    end
  end
end
