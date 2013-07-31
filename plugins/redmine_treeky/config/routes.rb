# Route for favorite projects
match "favorite_projects/:action" => "favorite_projects"
match "favorite_projects/search" => "favorite_projects#searh", :as => "search_favorite_projects"

# Route for project custom field filter
post "custom_label_filter/:action" => "project_custom_label_filter"


