# encoding: utf-8

class SubscribesMailer < DbMailer
  default :from => CONFIG[:from_email], :subject => 'Подписки'

  def subscribes_send(user, companies, goods, services, campaigns, jobs, news)
    @user, @companies, @goods, @services, @campaigns, @jobs, @news = user, companies, goods, services, campaigns, jobs, news
    # TODO refactoring, not empty body
    Email.create(:from => CONFIG[:from_email], :to => user.email, :subject => 'Подписки', :body => '', :sended => true)
    mail(:to => user.email)
  end
end
