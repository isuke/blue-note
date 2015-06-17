class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.references :project , null: false, index: true
      t.string     :title   , null: false
      t.integer    :status  , null: false
      t.integer    :priority             , index: true
      t.integer    :point

      t.timestamps null: false
    end
  end
end
