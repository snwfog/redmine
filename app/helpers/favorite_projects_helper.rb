module FavoriteProjectsHelper
  def favorite_tag(project, user, options={})
    return '' unless user && user.logged? && user.member_of?(project)

    # TODO: Use relationship instead of just static methods

    favorite = user.favorite?(project)
    image_tag = content_tag(:div, '', class: (favorite ? :fav : :unfav))
    if favorite
      fav_project = user.favorite_projects.select{|p| p.id == project.id}
      url = link_to(image_tag, fav_project, method: :delete, remote: true)
    else
      url = link_to(image_tag, {controller: 'favorite_projects', project_id: project.id}, method: :post, remote: true)
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
