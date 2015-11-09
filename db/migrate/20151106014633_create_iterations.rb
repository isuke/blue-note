class CreateIterations < ActiveRecord::Migration
  def change
    create_table :iterations do |t|
      t.references :project , null: false, index: true
      t.integer    :number  , null: false
      t.date       :start_at, null: false
      t.date       :end_at  , null: false

      t.timestamps null: false
    end
    add_index :iterations, [:project_id, :number], unique: true
  end
end
