# encoding: utf-8

class CompanyPanel::CompaniesUsersController < CompanyPanel::BaseController
  before_filter :find_company

  def index
    @company_users = [current_user, @company.users].flatten
  end

  def create
    current_user.account.users << User.find(params[:company_user]['user_id'])
    redirect_to company_panel_companies_users_path
  end

  def destroy
    current_user.account.users.delete User.find(params[:id])
    redirect_to company_panel_companies_users_path
  end

  def search
    @users = @company.users.where('f_name like :q or l_name like :q or m_name like :q', :q => "%#{params[:q].strip}%").where('users.id != ?', current_user.id)
    respond_to do |format|
      format.json { render :json => @users }
    end
  end

  def user_phone_email
     user = User.find(params[:id]) if params[:id]
     if user
          if params[:type].eql? "email"
               user.email = params[:data]
          else
               user.phone = params[:data]
          end
     user.save
     end
     head :ok
  end

  def user_by_email
    if @user = User.find_by_email(params[:email])
      render :json => @user
    else
      render :json => {}
    end
  end

  def invite
    InvitesMailer.invite_send(current_user, params[:company_user]['email']).deliver unless User.find_by_email(params[:company_user]['email'])
    render :text => 'ok'
  end

  private

  def find_company
    @company = current_user.account
  end
end
