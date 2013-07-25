class ProjectCustomLabelFilterController < ApplicationController
  unloadable
  before_filter :get_user

  def update
    field_ids = params[:project_custom_field]
    field_ids.each do |field, check|
      favorite = FavoriteProjectCustomField.fav(@user.id, field)
      if check == "1" && favorite.nil?
        FavoriteProjectCustomField.create(user_id: @user.id, custom_field_id: field)
      elsif check == "0" && favorite
        FavoriteProjectCustomField.delete_all(user_id: @user.id, custom_field_id: field)
      end
    end

    respond_to do |format|
      format.html { redirect_to :back }
      format.js { render partial: 'set_filter' }
    end
  end

  private
  def get_user
    @user = User.current
  end
end