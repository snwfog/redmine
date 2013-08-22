class TagDescriptorsController < ApplicationController
  unloadable
  before_filter :get_tag, only: [:edit, :destroy, :update]

  def index
    # TODO: This part needs to be refactored into models
    @tag_count = TagDescriptor.joins("LEFT JOIN tags ON tags.tag_descriptor_id = tag_descriptors.id").group('tag_descriptors.id').order("count_issue_id DESC").count("issue_id")
    @tag_count = @tag_count.inject({}) { |t, pair| t[pair[0]] = pair[1]; t }
    @tags = TagDescriptor.all.inject([]) do |h, tag|
      h << { tag: tag, tag_count: @tag_count[tag.id] }
      h
    end
    @tags.sort_by!{ |tag| tag[:tag_count] }.reverse!
    @tags
  end

  def create
    descriptions = params[:tag_descriptor][:description].split(",")
    descriptions.each do |desc|
      @tag = TagDescriptor.new(description: desc)
      if @tag.save
        flash[:notice] ||= []
        flash[:notice] << "Succesfully created tag #{desc}"
      else
        flash[:error] ||= []
        flash[:error] << "Error creating tag #{desc}. Reason: #{@tag.errors.messages}."
      end
    end
    respond_to do |format|
      format.html do
        flash[:notice] = flash[:notice].join("<br />").html_safe if flash[:notice]
        flash[:error] = flash[:error].join("<br />").html_safe if flash[:error]
        redirect_to tag_descriptors_path
      end
    end
  end

  def new

  end

  def edit
    respond_to do |format|
      format.js
    end
  end

  def show
  end

  def update
    if params.has_key?(:tag_descriptor) && @tag.update_attributes(params[:tag_descriptor])
      respond_to do |format|
        format.js { render json: @tag, status: :ok }
      end
    else
      respond_to do |format|
        format.js { render json: @tag.errors, status: :error }
      end
    end
  end

  def destroy
    if @tag.destroy
      respond_to do |format|
        flash[:notice] = "Succesfully deleted #{@tag.description} tag."
        format.html { redirect_to tag_descriptors_path }
        #format.js { render partial: 'remove_tag' }
      end
    end
  end
  
  private
  def get_tag
    @tag = TagDescriptor.find(params[:id])
  end
end
