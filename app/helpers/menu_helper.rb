# encoding: utf-8

module MenuHelper
  def menu_hash
    YAML.load_file('config/menu.yml')['menu']
  end
    
  # TODO unlimited level count with recursion
  def render_menu
    res = '<ul class="nav-level-1">'
    menu_hash.each do |nav1|
      res += "<li><a href=\"#{parse_erb(nav1['href'])}\">#{nav1['name']}</a>"
      if nav1['children']
        res += '<ul class="nav-level-2">'
        nav1['children'].each do |nav2|
          res += "<li><a href=\"#{parse_erb(nav2['href'])}\">#{nav2['name']}</a>"
          if nav2['children']
            res += '<ul class="nav-level-3">'
            nav2['children'].each do |nav3|
              res += "<li><a href=\"#{parse_erb(nav3['href'])}\">#{nav3['name']}</a></li>"
            end
            res += '</ul>'
          end
          res += '</li>'
        end
        res += '</ul>'
      end
      res += '</li>'
    end
    raw (res += '</ul>')
  end

  # NOTE controller = params[:controller] не подходит. так как часто передаётся controller = nil
  def menu_siblings controller = nil, menu = menu_hash
    controller ||= params[:controller]
    menu.each do |m|
      if parse_erb(m['href']) == request.path || (Rails.application.routes.recognize_path(parse_erb(m['href']))[:controller] rescue nil) == controller
        return menu
      elsif m['children']
        if (res = menu_siblings controller, m['children']).any?
          return res
        end
      end
    end
    []
  end
end
