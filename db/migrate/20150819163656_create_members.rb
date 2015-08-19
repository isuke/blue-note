class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.references :user    , null: false, index: true
      t.references :project , null: false, index: true
      t.integer    :role    , null: false

      t.timestamps null: false

      t.index [:user_id, :project_id], unique: true
    end
  end
end
