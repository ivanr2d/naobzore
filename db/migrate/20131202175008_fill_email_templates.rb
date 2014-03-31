class FillEmailTemplates < ActiveRecord::Migration
  def up
    Dir.glob(File.join(Rails.root, 'app/views/*_mailer')).each do |mailer_dir|
      Dir.entries(mailer_dir).select { |e| !['..', '.'].include?(e) }.each do |email_template|
        puts email_template
        EmailTemplate.create(:name => email_template.sub('.html.erb', ''), :body => File.read(File.join(mailer_dir, email_template)))
      end
    end
  end

  def down
    EmailTemplate.delete_all
  end
end
