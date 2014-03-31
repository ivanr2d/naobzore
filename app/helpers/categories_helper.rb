module CategoriesHelper
  def render_categories categories = Category.main, level = 1
    res = "<ul class=\"categories level-#{level}\">"
    categories.each do |category|
      children = category.children
      res += "<li class=\"#{children.any? ? 'active' : ''}\"><div class=\"container\" data-setting=\"internal_color_background\"><a href=\"#\">#{category.title}</a><p>#{category.id}</p><div class=\"clear\"></div></div>"
      if children.any?
        res += render_categories(children, level + 1)
      end
      res += "</li>"
    end
    res += "</ul>"
    raw res
  end

  # XXX categories.map is better solution
  def render_category_options(parent_id, categories = Category.top, level = 0) 
    raw(categories.map do |category|
      "<option value=\"#{category.id}\" #{'selected' if parent_id == category.id}>#{'&nbsp;&nbsp;' * level}#{category.title}</option>" +
      render_category_options(parent_id, category.children, level + 1)
    end.join)
  end
end
