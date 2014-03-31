class DbMailer < ActionMailer::Base
  include ApplicationHelper

  def mail headers = {}, &body
    if !headers[:body] && email_template = EmailTemplate.find_by_name(action_name)
      headers.merge!(:body => parse_erb(email_template.body), :content_type => 'text/html')
    end
    super headers, &body
  end
end
