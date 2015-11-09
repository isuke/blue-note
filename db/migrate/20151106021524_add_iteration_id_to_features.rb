class AddIterationIdToFeatures < ActiveRecord::Migration
  def change
    add_column :features, :iteration_id, :integer, null: true, after: :project_id
  end
end
