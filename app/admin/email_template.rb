ActiveAdmin.register EmailTemplate do
  menu false

  index do
    column :name
    column :description do |email_template|
      truncate email_template.description, :length => 100
    end
    column :body do |email_template|
      truncate email_template.body, :length => 200
    end
  end
end
