module WidgetsHelperHelper
  def render_widgets widgets = @widgets, big = true
    render :partial => 'company_panel/shared/widget', :collection => Widget.where(:translit => widgets).sort { |w1, w2| widgets.index(w1.translit.to_sym) <=> widgets.index(w2.translit.to_sym) }, :locals => (big ? {} : { :class_name => 'extra' })
  end
end
