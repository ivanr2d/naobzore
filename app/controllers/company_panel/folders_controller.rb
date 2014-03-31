# encoding: utf-8

class CompanyPanel::FoldersController < CompanyPanel::BaseController
	before_filter :find_folder, :only => [:update, :destroy]

	def create
		respond_to do |format|
			format.json do
				@folder = Folder.new(params[:folder])
				@success = @folder.save
				render_response
			end
		end
	end

	def update
		respond_to do |format|
			format.json do
				@success = @folder.update_attributes(params[:folder])
				render_response
			end
		end
	end

	def destroy
		@folder.destroy
		render :nothing => true
	end

	private

	def find_folder
		@folder = @company.folders.find(params[:id])
	end

	def render_response
		if @success
			render :json => { :folder => @folder, :template => render_to_string(:partial => 'company_panel/folders/folder.html', :object => @folder) }
		else
			render :json => { :errors => @folder.errors.full_messages }
		end
	end
end