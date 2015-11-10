json.array!(@members) do |member|
  json.id         member.id
  json.user_name  member.user.name
  json.user_email member.user.email
  json.role       member.role
  json.role_value member.role.value
  json.created_at member.created_at
  json.updated_at member.updated_at
end
