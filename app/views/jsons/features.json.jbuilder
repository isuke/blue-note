json.array!(@features) do |feature|
  json.id       feature.id
  json.title    feature.title
  json.status   feature.status
  json.priority feature.priority
  json.point    feature.point
  json.iteration_number feature.iteration.try(:number)
end
