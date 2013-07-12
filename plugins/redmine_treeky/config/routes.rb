match "favorite_projects/:action" => "favorite_projects"
match "favorite_projects/search" => "favorite_project#search", :as => "search_favorite_projects"