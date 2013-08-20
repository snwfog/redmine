class FavoriteProjectsController < ApplicationController
  unloadable
  before_filter :find_project_by_project_id, :except => :search

  def create
    fav_project = FavoriteProject.new(project_id: @project.id)
    if fav_project.save
      # Respond only to js, no need for respond_to block
      render_api_ok
    else
      # Nothing: true must always be set, for ajax request response
      render_error status: :bad_request
    end
  end

  def destroy

  end

  # Returns the css class used to identify watch links for a given +object+
  def favorite_css(object)
    "#{object.class.to_s.underscore}-#{object.id}-favorite"
  end
end
