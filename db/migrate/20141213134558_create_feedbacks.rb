class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.text :comment
      t.string :url
      t.integer :user_id

      t.timestamps null: false
    end

    add_index :feedbacks, :user_id
  end
end
