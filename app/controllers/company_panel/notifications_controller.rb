class CompanyPanel::NotificationsController < CompanyPanel::BaseController
  def index
    @notifications = current_user.received_messages.mtype_eq(:notification).unread_by(current_user)
    Message.mark_as_read! @notifications.to_a, :for => current_user
  end
end
