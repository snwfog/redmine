class FavoriteProjectsController < ApplicationController
  unloadable
  before_filter :find_project_by_project_id, :except => :search

  def favorite
    if @project.respond_to?(:visible?) && !@project.visible?(User.current)
      render_403
    else
      set_favorite(User.current, true)
    end
  end

  def unfavorite_project
    set_favorite(User.current, false)
  end

  # Returns the css class used to identify watch links for a given +object+
  def favorite_css(object)
    "#{object.class.to_s.underscore}-#{object.id}-favorite"
  end

  private

  def set_favorite(user, favorite)
    # Move this validation to the model
    favorite_project = FavoriteProject.find_by_project_id_and_user_id(@project.id, user.id)

    if favorite && favorite_project.nil?
      FavoriteProject.create(project_id: @project.id, user_id: user.id)
    else
      favorite_project.destroy if favorite_project
    end

    respond_to do |format|
      format.html { redirect_to :back }
      format.js { render :partial => 'set_favorite' }
    end

  rescue ::ActionController::RedirectBackError
    render :text => (favorite ? 'Favorite added.' : 'Favorite removed.'), :layout => true
  end
end
