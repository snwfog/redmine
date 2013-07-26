class ProjectCustomLabelFilterController < ApplicationController
  unloadable
  before_filter :get_user

  def update
    field_ids = params[:project_custom_field].select{|k, v| v == "1"}.keys
    favorite_field_ids = @user.favorite_project_custom_field_ids

    mark_as_favorite = field_ids - favorite_field_ids
    mark_to_delete = favorite_field_ids - field_ids

    # Create the record individually
    mark_as_favorite.each do |field_id|
      FavoriteProjectCustomField.create(user_id: @user.id, custom_field_id: field_id)
    end

    # Mass delete the records
    FavoriteProjectCustomField.delete_all(["custom_field_id IN (?) AND user_id = ?", mark_to_delete, @user.id])

    # respond_to do |format|
    #   format.html { redirect_to :back }
    #   format.js { render partial: 'set_filter' }
    # end
  end

  private
  def get_user
    @user = User.current
  end
end