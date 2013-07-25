class ProjectCustomLabelFilterController < ApplicationController
  unloadable
  before_filter :get_user

  def update
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