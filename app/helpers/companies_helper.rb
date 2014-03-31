module CompaniesHelper
  def render_company_catalog catalog = @company.catalog(@company.goods.for_user(current_user) + @company.services.for_user(current_user)), level = 1
    res = "<ul class=\"categories level-#{level}\">"
    catalog.keys.each do |category|
      children = catalog[category][:children]
      res += "<li class=\"\"><div class=\"container\"><a href=\"#{children.any? || !category.cat_type ? '#' : send("#{category.cat_type.tableize}_path".to_sym, :category_id => category.id)}\">#{category.title}</a><p>#{catalog[category][:count]}</p><div class=\"clear\"></div></div>"
      if children.any?
        res += render_company_catalog children, level + 1
      end
      res += '</li>'
    end
    res += '</ul>'
    res
  end
end
