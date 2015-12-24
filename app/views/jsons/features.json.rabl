collection @features

attributes :id
attributes :title
attributes :status
attributes :priority
attributes :point
code :iteration_number do |feature| feature.iteration.try(:number) end
attributes :created_at
attributes :updated_at
