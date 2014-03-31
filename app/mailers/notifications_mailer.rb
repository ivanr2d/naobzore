# encoding: utf-8

class NotificationsMailer < DbMailer
  default :from => CONFIG[:from_email], :subject => 'Ваш баланс близок к нулю'

  def balance_notification user
    @user = user
    @company = user.company
    mail(:to => user.email)
  end
end
