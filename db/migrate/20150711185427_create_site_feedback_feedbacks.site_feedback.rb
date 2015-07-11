# This migration comes from site_feedback (originally 20150710183009)
class CreateSiteFeedbackFeedbacks < ActiveRecord::Migration
  def change
    create_table :site_feedback_feedbacks do |t|
      t.integer :user_id
      t.string :email
      t.string :name
      t.string :attachment
      t.text :body
      t.integer :status

      t.timestamps null: false
    end

    add_index :site_feedback_feedbacks, :user_id
    add_index :site_feedback_feedbacks, :status
    add_index :site_feedback_feedbacks, :email, unique: true

  end
end
