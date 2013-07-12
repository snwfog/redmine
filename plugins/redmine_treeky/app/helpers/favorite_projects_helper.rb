module FavoriteProjectsHelper
  def favorite_tag(project, user=User.current, option={})
    image_tag('fav.png')
    # return '' unless user && user.logged? && user.member_of?(project)
    # favorite = FavoriteProject.favorite?(project.id, user.id)
  end
end
