class ProjectCustomLabelFilterController < ApplicationController
  unloadable
  before_filter :get_user

  def update_custom_fields
    field_ids = params[:project_custom_field].select{|k, v| v == "1"}.keys

    # Mass delete all the records
    FavoriteProjectCustomField.delete_all(["user_id = ?", @user.id])

    # Create the record individually
    field_ids.each do |field_id|
      FavoriteProjectCustomField.create(user_id: @user.id, custom_field_id: field_id)
    end

    respond_to do |format|
      format.js { render nothing: true, status: :found }
      # format.js { render partial: 'set_filter' }
      format.html { redirect_to :back }
    end
  end

  def update_extra_columns
    extra_columns = @user.favorite_project_extra_column
    if extra_columns.update_attributes(params[:favorite_project_extra_column])
      respond_to do |format|
        format.js { render nothing: true, status: :found }
        # format.js { render partial: 'set_filter' }
        format.html { redirect_to :back }
      end
    end
  end

  private
  def get_user
    @user = User.current
  end
end