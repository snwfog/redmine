post 'favorite_project/:id', to: 'favorite_projects#create', as: :create_favorite_project
delete 'favorite_project/:id', to: 'favorite_projects#destroy', as: :delete_favorite_project

# Route for project custom field filter
post "custom_label_filter/:action" => "project_custom_label_filter"


