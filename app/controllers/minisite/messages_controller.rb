# encoding: utf-8

class Minisite::MessagesController < Minisite::BaseController
  def create
		respond_to do |format|
			format.js do
        to_id = params[:message].delete('to_id')
				@message = Message.new(params[:message])
        @success = @message.save
        if to_id.present?
          @message.receivers << User.find_by_id(to_id)
        end
			end
		end
	end
end
