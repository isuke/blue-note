collection @members

attributes :id
code :user_name  do |member| member.user.name end
code :user_email do |member| member.user.email end
attributes :role
code :role_value do |member| member.role.value end
attributes :created_at
attributes :updated_at
