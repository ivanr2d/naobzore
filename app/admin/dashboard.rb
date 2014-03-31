# coding: utf-8
ActiveAdmin.register_page "Dashboard" do

  #menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }
  
  menu :label => "Главная", :priority => 1

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    render :partial => 'table_of_content'

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end 
  end
end
