# encoding: utf-8

class InvitesMailer < DbMailer
  default :from => CONFIG[:from_email], :subject => 'Приглашение'

  def invite_send(user, email)
    @user, @email = user, email
    mail(:to => email)
  end
end
