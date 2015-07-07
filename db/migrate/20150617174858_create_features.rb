class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.references :project , null: false, index: true
      t.string     :title   , null: false
      t.integer    :status  , null: false
      t.integer    :priority
      t.integer    :point

      t.timestamps null: false
    end
    add_index :features, [:project_id, :status]
    add_index :features, [:project_id, :priority]
    add_index :features, [:project_id, :point]
  end
end
