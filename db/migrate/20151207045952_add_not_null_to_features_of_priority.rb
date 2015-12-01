class AddNotNullToFeaturesOfPriority < ActiveRecord::Migration
  def up
    set_priority
    change_column_null :features, :priority, false
  end

  def down
    change_column_null :features, :priority, true
  end

  def set_priority
    Feature.where(priority: nil).each do |feature|
      feature.insert_at(1)
    end
  end
end
