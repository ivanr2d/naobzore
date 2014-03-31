# encoding: utf-8

class CompanyPanel::MessagesController < CompanyPanel::BaseController
  def index
  end

  def dialog
	@h1 = 'Диалоги'
  end

	def create
		respond_to do |format|
			format.js do
        to_id = params[:message].delete('to_id')
				@message = Message.new(params[:message])
        @success = @message.save
        @message.receivers << User.find_by_id(to_id)
			end
		end
	end
end
