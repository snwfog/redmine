module FavoriteProjectsHelper
  def favorite_tag(project, user, options={})
    return '' unless user && user.logged? && user.member_of?(project)

    if user.favorite?(project)
      url = button_to('', delete_favorite_project_path(project.id), data: {project_id: project.id}, method: :delete, class: :fav, remote: true)
    else
      url = button_to('', create_favorite_project_path(project.id), data: {project_id: project.id}, method: :post, class: :unfav, remote: true)
    end

    content_tag("span", url, :id => "favorite_project_#{project.id}").html_safe
  end

  # Returns the css class used to identify watch links for a given +object+
  #def favorite_css(objects)
  #  objects = Array.wrap(objects)
  #  id = (objects.size == 1 ? objects.first.id : 'bulk')
  #  "#{objects.first.class.to_s.underscore}-#{object.id}-favorite"
  #end

  #def favorite_project_modules_links(project)
  #  links = []
  #  menu_items_for(:project_menu, project) do |node|
  #     links << link_to(extract_node_details(node, project)[0], extract_node_details(node, project)[1]) unless node.name == :overview
  #  end
  #  links.join(", ").html_safe
  #end
end
