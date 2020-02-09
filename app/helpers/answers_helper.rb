module AnswersHelper
  def field_id(resource, prefix)
    if resource.id
      "#{prefix}-#{resource.id}"
    else
      prefix
    end
  end
end
