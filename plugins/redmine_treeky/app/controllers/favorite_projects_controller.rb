class FavoriteProjectsController < ApplicationController
  unloadable
  before_filter :find_favorite_project, only: :destroy

  def create
    project = Project.find(params[:id]) if Project.exists?(params[:id])
    fav_project = FavoriteProject.new(project_id: project.id) unless project.nil?

    if fav_project.save
      # Respond only to js, no need for respond_to block
      render_api_ok
    else
      # Nothing: true must always be set, for ajax request response
      render_error status: :bad_request
    end
  end

  def destroy
    if @favorite_project.destroy
      render_api_ok
    else
      render_error status: :method_not_allowed
    end
  end

  # Returns the css class used to identify watch links for a given +object+
  def favorite_css(object)
    "#{object.class.to_s.underscore}-#{object.id}-favorite"
  end

  private
  def find_favorite_project
    @favorite_project = FavoriteProject.find_by_user_id_and_project_id(User.current.id, params[:id])
  end
end
