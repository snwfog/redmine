class QueryTagDescriptionColumn < QueryColumn
  def initialize(tag_field, options={})
    super(tag_field, options)
    self.groupable = self.sortable.dup
  end

  def caption
    name.to_s + "TAG_DESCRIPTION_PLACEHOLDER"
  end

  def value(object)
    lst = object.tags.inject("") do |all, tag|
      all += "<li>#{tag.description}</li>"
      all
    end

    "<ul class=\"tags\">#{lst}</ul>".html_safe
  end
end


