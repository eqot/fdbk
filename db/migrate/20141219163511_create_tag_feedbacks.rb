class CreateTagFeedbacks < ActiveRecord::Migration
  def change
    create_table :tag_feedbacks do |t|
      t.integer :tag_id
      t.integer :feedback_id

      t.timestamps null: false
    end

    add_index :tag_feedbacks, [:tag_id, :feedback_id], unique: true
  end
end
