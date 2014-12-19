class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :label

      t.timestamps null: false
    end

    add_index :tags, :label
  end
end
