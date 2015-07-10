class CreateSiteFeedbackFeedbacks < ActiveRecord::Migration
  def change
    create_table :site_feedback_feedbacks do |t|
      t.integer :user_id
      t.string :email
      t.string :name
      t.text :body

      t.timestamps null: false
    end
    add_index :site_feedback_feedbacks, :user_id
    add_index :site_feedback_feedbacks, :email
  end
end
