class QueryTagDescriptionColumn < QueryColumn
  def initialize(tag_field, options={})
    super(tag_field, options)
  end

  def caption
    name.to_s + "TAG_DESCRIPTION_PLACEHOLDER"
  end

  #def value(object)
  #  tags = object.tags.empty? ? "" : object.tags.map(&:description).sort
  #end

  def value(object)
    lst = object.tags.inject("") do |all, tag|
      unless tag.nil?
        all += "<li>#{tag.description}</li>"
      end
      all
    end

    "<ul class=\"tags\">#{lst}</ul>".html_safe
  end
end


